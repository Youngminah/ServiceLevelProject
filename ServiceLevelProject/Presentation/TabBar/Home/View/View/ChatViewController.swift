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

    private let backBarButton = UIBarButtonItem()
    private let detailBarButton = UIBarButtonItem()
    private let headerView = ChatHeaderView()
    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let inputTextView = InputTextView()
    private let sendButton = UIButton()
    private let bottomSheetView = UIView()

    private lazy var input = ChatViewModel.Input(
        viewDidLoad: Observable.just(()),
        backBarButtonTap: backBarButton.rx.tap.asSignal(),
        detailBarButtonTap: detailBarButton.rx.tap.asSignal()
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
        output.showToastAction
            .emit(onNext: { [unowned self] message in
                self.view.makeToast(message, position: .top)
            })
            .disposed(by: disposeBag)

        output.chatList
            .drive(tableView.rx.items) { tv, index, chat in
                if chat.from == "me" {
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
        detailBarButton.image = UIImage(systemName: "ellipsis")
        detailBarButton.style = .plain
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
