//
//  BackgroundViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import UIKit
import RxCocoa
import RxSwift

final class BackgroundViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let disposeBag = DisposeBag()

    private let backgroundLists = BehaviorRelay<[SesacBackgroundCase]>(value: SesacBackgroundCase.allCases)

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        setViews()
        bind()
        setConstraints()
    }

    private func bind() {
        backgroundLists
            .asDriver()
            .drive(tableView.rx.items) { tv, index, item in
                let cell = tv.dequeueReusableCell(withIdentifier: BackgroundCell.identifier) as! BackgroundCell
                cell.updateUI(background: item)
                return cell
            }
            .disposed(by: disposeBag)

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
        tableView.register(BackgroundCell.self, forCellReuseIdentifier: BackgroundCell.identifier)
        tableView.separatorColor = .clear
        tableView.sectionHeaderHeight = 0
        tableView.rowHeight = 200.0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.backgroundColor = .white
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 1
        }
    }
}
