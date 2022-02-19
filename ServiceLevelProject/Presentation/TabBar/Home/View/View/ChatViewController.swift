//
//  ChatViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/13.
//

import UIKit
import RxKeyboard
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

final class ChatViewController: UIViewController {

    private lazy var detailBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(detailBarButtonTap))
    private lazy var dropDownTopStackView = UIStackView(arrangedSubviews: [reportButton, cancelButton, reviewButton])

    private let backBarButton = UIBarButtonItem()
    private let headerView = ChatHeaderView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let reportButton = UIButton()
    private let cancelButton = UIButton()
    private let reviewButton = UIButton()
    private let backgroundView = UIView()
    private let inputTextView = InputTextView()
    private let sendButton = UIButton()
    private let bottomSheetView = UIView()

    private lazy var input = ChatViewModel.Input(
        viewDidLoad: Observable.just(()),
        viewDidDisappear: self.rx.viewDidDisappear.asSignal(),
        backBarButtonTap: backBarButton.rx.tap.asSignal(),
        sendChat: sendButton.rx.tap.withLatestFrom(inputTextView.rx.validText).asSignal(onErrorJustReturn: ""),
        reportMenuButtonTap: reportButton.rx.tap.asSignal(),
        cancelMenuButtonTap: cancelButton.rx.tap.asSignal(),
        reviewMenuButtonTap: reviewButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let viewModel: ChatViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("ChatViewController: fatal error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfiguration()
        setViews()
        setConstraints()
        bind()
        bindKeyboard()
    }

    private func bind() {
        output.navigationTitle
            .drive(self.rx.title)
            .disposed(by: disposeBag)

        output.navigationTitle
            .map { $0 + "님과 매칭되었습니다."}
            .drive(self.headerView.topTitleLabel.rx.text)
            .disposed(by: disposeBag)

        output.showToastAction
            .emit(onNext: { [unowned self] message in
                self.view.makeToast(message, position: .top)
            })
            .disposed(by: disposeBag)

        output.chatList
            .drive(tableView.rx.items) { tv, index, chat in
                if chat.from == "aV43LR1IKjUenCcqFIX44lQHUlz1" {
                    let cell = tv.dequeueReusableCell(withIdentifier: SendChatCell.identifier) as! SendChatCell
                    cell.updateUI(chat: chat)
                    return cell
                } else {
                    let cell = tv.dequeueReusableCell(withIdentifier: ReceivedChatCell.identifier) as! ReceivedChatCell
                    cell.updateUI(chat: chat)
                    return cell
                }
            }
            .disposed(by: disposeBag)

        output.chatList
            .filter { $0.last?.from == "aV43LR1IKjUenCcqFIX44lQHUlz1" }
            .map { $0.count - 1 }
            .drive(onNext: { [weak self] index in
                self?.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .bottom, animated: true)
            })
            .disposed(by: disposeBag)

        output.resetTextViewAction
            .map { "" }
            .emit(to: self.inputTextView.rx.text)
            .disposed(by: disposeBag)

        output.dismissDetailMenu
            .emit(onNext: { [weak self] in
                self?.removeAnimation()
            })
            .disposed(by: disposeBag)
    }

    @objc
    private func detailBarButtonTap() {
        if view.subviews.contains(backgroundView) {
            removeAnimation()
        } else {
            setDetailMenuView()
            showAnimation()
        }
    }

    private func setViews() {
        view.addSubview(inputTextView)
        view.addSubview(sendButton)
        view.addSubview(tableView)
    }

    private func setConstraints() {
        inputTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.greaterThanOrEqualTo(52)
        }
        sendButton.snp.makeConstraints { make in
            make.right.equalTo(inputTextView.snp.right).offset(-16)
            make.width.height.equalTo(24)
            make.centerY.equalTo(inputTextView)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(inputTextView.snp.top).offset(-16)
        }
    }

    private func setConfiguration() {
        view.backgroundColor = .white
        backBarButton.image = Asset.backNarrow.image
        backBarButton.style = .plain
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = detailBarButton

        tableView.register(ChatHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: ChatHeaderView.identifier)
        tableView.register(SendChatCell.self,
                           forCellReuseIdentifier: SendChatCell.identifier)
        tableView.register(ReceivedChatCell.self,
                           forCellReuseIdentifier: ReceivedChatCell.identifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.sectionHeaderHeight = 130
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear

        reportButton.setImage(Asset.reportMenu.image, for: .normal)
        cancelButton.setImage(Asset.cancelMenu.image, for: .normal)
        reviewButton.setImage(Asset.reviewMenu.image, for: .normal)
        dropDownTopStackView.distribution = .fillEqually
        dropDownTopStackView.backgroundColor = .white

        sendButton.setImage(Asset.nextFill.image, for: .normal)
    }

    private func bindKeyboard() {
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardChangedHeight in
                self?.raiseKeyboardWithButton(keyboardChangedHeight: keyboardChangedHeight)
            })
            .disposed(by: disposeBag)

        view.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.inputTextView.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }

    func raiseKeyboardWithButton(keyboardChangedHeight: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var bottomOffset = self.view.safeAreaInsets.bottom - keyboardChangedHeight - 16
            if keyboardChangedHeight == 0 { bottomOffset = -16 }
            self.inputTextView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(bottomOffset)
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension ChatViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
}

// MARK: - Detail Top View
extension ChatViewController {

    private func setDetailMenuView() {
        backgroundView.backgroundColor = .black.withAlphaComponent(0.3)
        view.addSubview(backgroundView)
        backgroundView.addSubview(dropDownTopStackView)
        backgroundView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        dropDownTopStackView.snp.makeConstraints { make in
            make.height.equalTo(view.snp.width).multipliedBy(72 / 375.0)
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
                .offset(-(UIScreen.main.bounds.width * 72 / 375.0))
        }
    }

    private func showAnimation() {
        backgroundView.alpha = 0
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self = self else { return }
                self.backgroundView.alpha = 1
                self.dropDownTopStackView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.width * 72 / 375.0)
            })
        }
    }

    private func removeAnimation(complition: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2, animations: {
                self.dropDownTopStackView.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.backgroundView.removeFromSuperview()
                self.dropDownTopStackView.removeFromSuperview()
                complition?()
            })
        }
    }
}
