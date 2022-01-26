//
//  MyPageViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

class MyPageViewController: UIViewController {

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setViews()
        setConstraints()
        setConfigurations()
        bind()
    }

    private func bind() {

    }

    private func setViews() {
        view.addSubview(tableView)
    }

    private func setConstraints() {

    }

    private func setConfigurations() {

    }
}
