//
//  UITableView+Rx.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/11.
//

import UIKit.UITableView
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    func isEmpty(title: String, message: String) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setNoDataPlaceholder(title: title, message: message)
            } else {
                tableView.removeNoDataPlaceholder()
            }
        }
    }
}
