//
//  HobbySearchViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import RxKeyboard
import SnapKit

class HobbySearchViewController: UIViewController {

    private let backBarButton = UIBarButtonItem()
    private let pauseSearchBarButton = UIBarButtonItem()
    private let nearSesacButton = TabButton(title: "주변 새싹", isSelected: true)
    private let receivedRequestButton = TabButton(title: "받은 요청")
    private let underBarView = UIView()
    private let slidingBarView = UIView()
    private let tableView = UITableView()
    private let bottomSheetView = UIView()
    private let refreshButton = UIButton()
    private let changeHobbyButton = SelectionButton(title: "취미 변경하기")

    private lazy var input = HobbySearchViewModel.Input(
        viewWillAppear: self.rx.viewWillAppear.asSignal(),
        backBarButtonTap: backBarButton.rx.tap.asSignal(),
        pauseSearchBarButtonTap: pauseSearchBarButton.rx.tap.asSignal(),
        nearSesacButtonTap: nearSesacButton.rx.tap.asSignal(),
        receivedRequestButtonTap: receivedRequestButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let viewModel: HobbySearchViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: HobbySearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("HomeSearchViewController: fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        setViews()
        bind()
        setConstraints()
    }

    private func bind() {
        output.hobbyItems
            .map { return $0.count <= 0 }
            .drive(tableView.rx.isEmpty(
                title: SearchSesacStatus.near.emptyTitle,
                message: SearchSesacStatus.request.emptyMessage)
            )
            .disposed(by: disposeBag)

        output.hobbyItems
            .drive(tableView.rx.items) { tv, index, element in
                let cell = tv.dequeueReusableCell(withIdentifier: CardCell.identifier) as! CardCell
                cell.updateUI(item: element)
                return cell
            }
            .disposed(by: disposeBag)

        output.receivedRequestItems
            .map { return $0.count <= 0 }
            .drive(tableView.rx.isEmpty(
                title: SearchSesacStatus.near.emptyTitle,
                message: SearchSesacStatus.request.emptyTitle)
            )
            .disposed(by: disposeBag)

        output.receivedRequestItems
            .map { return !($0.count <= 0) }
            .drive(bottomSheetView.rx.isHidden)
            .disposed(by: disposeBag)

        output.hobbyItems
            .map { return !($0.count <= 0) }
            .drive(bottomSheetView.rx.isHidden)
            .disposed(by: disposeBag)

        output.nearSecacButtonSelectedAction
            .emit(onNext: { [weak self] in
                self?.nearSesacButton.isSelected = true
                self?.receivedRequestButton.isSelected = false
                self?.underBarSlideAnimation(moveX: 0)
            })
            .disposed(by: disposeBag)

        output.receivedRequestButtonSelectedAction
            .emit(onNext: { [weak self] in
                self?.receivedRequestButton.isSelected = true
                self?.nearSesacButton.isSelected = false
                self?.underBarSlideAnimation(moveX: UIScreen.main.bounds.width / 2)
            })
            .disposed(by: disposeBag)
    }

    private func setViews() {
        view.addSubview(nearSesacButton)
        view.addSubview(receivedRequestButton)
        view.addSubview(underBarView)
        view.addSubview(tableView)
        view.addSubview(bottomSheetView)
        underBarView.addSubview(slidingBarView)
        bottomSheetView.addSubview(refreshButton)
        bottomSheetView.addSubview(changeHobbyButton)
    }

    private func setConstraints() {
        nearSesacButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(45)
        }
        receivedRequestButton.snp.makeConstraints { make in
            make.top.right.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(45)
        }
        underBarView.snp.makeConstraints { make in
            make.top.equalTo(nearSesacButton.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(2)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(underBarView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        slidingBarView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        bottomSheetView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        refreshButton.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(refreshButton.snp.height)
        }
        changeHobbyButton.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(refreshButton.snp.left).offset(-16)
        }
    }

    private func setConfigurations() {
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = pauseSearchBarButton
        navigationItem.leftBarButtonItem = backBarButton
        pauseSearchBarButton.title = "찾기 중단"
        pauseSearchBarButton.style = .plain
        backBarButton.image = Asset.backNarrow.image
        backBarButton.style = .plain
        underBarView.backgroundColor = .gray2
        slidingBarView.backgroundColor = .green
        changeHobbyButton.isSelected = true
        refreshButton.setImage(Asset.refresh.image, for: .normal)
        refreshButton.layer.borderWidth = 1
        refreshButton.layer.borderColor = UIColor.green.cgColor
        refreshButton.layer.cornerRadius = 8
        tableView.register(CardCell.self, forCellReuseIdentifier: CardCell.identifier)
        tableView.separatorColor = .clear
        bottomSheetView.isHidden = true
    }

    private func underBarSlideAnimation(moveX: CGFloat){
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8,initialSpringVelocity: 1, options: .allowUserInteraction, animations: { [weak self] in
            self?.slidingBarView.transform = CGAffineTransform(translationX: moveX, y: 0)
        }, completion: nil)
    }
}
