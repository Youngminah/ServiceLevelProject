//
//  MyPageEditViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import UIKit
import SnapKit

final class MyPageEditViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var saveBarButton = UIBarButtonItem(title: "저장",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(saveBarButtonTap))

    private var isToggle: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
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
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MyPageEditFooterView.identifier) as? MyPageEditFooterView else {
            return UITableViewHeaderFooterView()
        }
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isToggle ? 300 : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
