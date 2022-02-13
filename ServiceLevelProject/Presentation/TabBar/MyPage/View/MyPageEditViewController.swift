//
//  MyPageEditViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPageEditViewController: UIViewController {

    private let headerView = MyCardHeaderView()
    private let footerView = MyPageEditFooterView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var saveBarButton = UIBarButtonItem(title: "저장",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(saveBarButtonTap))
    private var isToggle: Bool = true

    private lazy var input = MyPageEditViewModel.Input(
        viewDidLoad: Observable.just(()).asSignal(onErrorJustReturn: ()),
        didWithdrawButtonTap: footerView.withdrawButtonTap,
        requestWithdrawSignal: requestWithdrawSignal.asSignal(),
        requestUpdateSignal: requestUpdateSignal.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let viewModel: MyPageEditViewModel
    private let disposeBag = DisposeBag()

    private let requestWithdrawSignal = PublishRelay<Void>()
    private let requestUpdateSignal = PublishRelay<UpdateUserInfo>()

    init(viewModel: MyPageEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("MyPageEditViewController: fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
        bind()
    }

    private func bind() {
        output.userInfo
            .emit(onNext: { [weak self] info in
                guard let self = self else { return }
                self.headerView.setHeaderView(info: info)
                let updateFooterInfo: UpdateUserInfo = (
                    info.searchable, info.ageMin, info.ageMax, info.gender, info.hobby
                )
                self.footerView.setUserInfo(info: updateFooterInfo)
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        output.showAlertAction
            .emit(onNext: {
                [weak self] in
                let alert = AlertView.init(
                    title: "정말 탈퇴하시겠습니까?",
                    message: "탈퇴하시면 새싹 프렌즈를 이용할 수 없어요ㅠ",
                    buttonStyle: .confirmAndCancel) { [weak self] in
                        self?.requestWithdrawSignal.accept(())
                    }
                alert.showAlert()
            })
            .disposed(by: disposeBag)
        
        output.indicatorAction
            .drive(onNext: {
                $0 ? IndicatorView.shared.show(backgoundColor: Asset.transparent.color) : IndicatorView.shared.hide()
            })
            .disposed(by: disposeBag)

        output.showToastAction
            .emit(onNext: { [unowned self] text in
                self.view.makeToast(text, position: .top)
            })
            .disposed(by: disposeBag)
    }

    @objc
    private func saveBarButtonTap() {
        let updateInfo = footerView.getUserInfo()
        requestUpdateSignal.accept(updateInfo)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
    }

    private func setViews() {
        tableView.register(MyCardHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: MyCardHeaderView.identifier)
        tableView.register(MyPageEditFooterView.self,
                           forHeaderFooterViewReuseIdentifier: MyPageEditFooterView.identifier)
        tableView.backgroundColor = .white
        navigationItem.rightBarButtonItem = saveBarButton
        view.addSubview(tableView)
    }

    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setConfigurations() {
        view.backgroundColor = .white
        tableView.delegate = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 1
        }
        headerView.toggleAddTarget(target: self, action: #selector(didPressToggle), event: .touchUpInside)
        headerView.setToggleButtonImage(isToggle: isToggle)
    }
}

extension MyPageEditViewController {

    @objc
    func didPressToggle() {
        isToggle = !isToggle
        headerView.updateConstraints(isToggle: isToggle)
        headerView.layoutIfNeeded()
        tableView.reloadSections([0], with: .none)
    }
}

extension MyPageEditViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = (UIScreen.main.bounds.width - 32) * (194.0 / 343) + 85
        return isToggle ? height : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
