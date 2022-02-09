//
//  MyPageViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

final class MyPageViewController: UIViewController, UIGestureRecognizerDelegate {

    private weak var coordinator: MyPageCoordinator?
    private let tableView = UITableView()

    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("NickNameVC fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
    }

    @objc
    private func headerViewTap(_ sender: UITapGestureRecognizer) {
        coordinator?.showMyPageEditViewController()
    }

    private func setViews() {
        view.addSubview(tableView)
    }

    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setConfigurations() {
        navigationItem.backButtonTitle = ""
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyPageMenuCell.self,
                           forCellReuseIdentifier: MyPageMenuCell.identifier)
        tableView.register(MyPageMenuHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: MyPageMenuHeaderView.identifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 1
        }
    }
}

extension MyPageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPageMenuCase.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageMenuCell.identifier, for: indexPath) as? MyPageMenuCell else {
            return UITableViewCell()
        }
        cell.updateUI(menu: MyPageMenuCase.allCases[indexPath.row])
        return cell
    }
}

extension MyPageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MyPageMenuHeaderView.identifier
        ) as? MyPageMenuHeaderView
        else {
            return UITableViewHeaderFooterView()
        }
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(self.headerViewTap)
        )
        tap.delegate = self
        headerView.addGestureRecognizer(tap)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyPageMenuCell.height
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MyPageMenuHeaderView.height
    }
}
