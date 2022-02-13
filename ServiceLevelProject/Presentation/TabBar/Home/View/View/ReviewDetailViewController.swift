//
//  ReviewDetailViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ReviewDetailViewController: UIViewController {

    private let tableView = UITableView()
    private let reviews: BehaviorRelay<[String]>
    private let disposeBag = DisposeBag()

    init(reviews: [String]) {
        self.reviews = BehaviorRelay<[String]>(value: reviews)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("ReviewDetailViewController: fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfiguration()
        setViews()
        setConstraints()
        bind()
    }

    private func bind() {
        reviews.asDriver()
            .drive(tableView.rx.items) { tv, index, element in
                let cell = tv.dequeueReusableCell(withIdentifier: ReviewCell.identifier) as! ReviewCell
                cell.updateUI(review: element)
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

    private func setConfiguration() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(ReviewCell.self,
                           forCellReuseIdentifier: ReviewCell.identifier)
    }
}
