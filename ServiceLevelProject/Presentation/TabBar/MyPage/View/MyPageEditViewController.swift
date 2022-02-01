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
        didWithdrawButtonTap: footerView.withdrawButtonTap,
        requestWithdrawSignal: requestWithdrawSignal.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let viewModel: MyPageEditViewModel
    private let disposdBag = DisposeBag()

    private let requestWithdrawSignal = PublishRelay<Void>()

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
        output.showAlertAction
            .emit(onNext: {
                let window = UIApplication.shared.windows.first!
                let alert = AlertView.init(
                    title: "정말 탈퇴하시겠습니까?",
                    message: "탈퇴하시면 새싹 프렌즈를 이용할 수 없어요ㅠ",
                    buttonStyle: .confirmAndCancel) { [weak self] in
                        self?.requestWithdrawSignal.accept(())
                    }
                alert.showAlert(in: window)
            })
            .disposed(by: disposdBag)
        
        output.indicatorAction
            .drive(onNext: {
                $0 ? IndicatorView.shared.show(backgoundColor: Asset.transparent.color) : IndicatorView.shared.hide()
            })
            .disposed(by: disposdBag)
    }

    @objc
    private func saveBarButtonTap() {
        let window = UIApplication.shared.windows.first!
        AlertView.init(
            title: "정말 탈퇴하시겠습니까?",
            message: "탈퇴하시면 새싹 프렌즈를 이용할 수 없어요ㅠ",
            buttonStyle: .confirmAndCancel,
            okCompletion: nil
        ).showAlert(in: window)
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
    }
}

extension MyPageEditViewController {

    @objc
    func didPressToggle() {
        isToggle = !isToggle
        tableView.reloadSections([0], with: .automatic)
    }
}

extension MyPageEditViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MyCardHeaderView.identifier) as? MyCardHeaderView else {
            return UITableViewHeaderFooterView()
        }
        headerView.toggleAddTarget(target: self, action: #selector(didPressToggle), event: .touchUpInside)
        headerView.setToggleButtonImage(isToggle: isToggle)
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isToggle ? 300 : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
