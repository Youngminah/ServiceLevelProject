//
//  MyPageEditViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import UIKit
import SnapKit

final class MyPageEditViewController: UIViewController {

    //private let button = SesacTitleButton(title: <#T##String#>)
    private let scrollView = UIScrollView()
    private lazy var stackView = UIStackView()
    private lazy var saveBarButton = UIBarButtonItem(title: "저장",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(saveBarButtonTap))

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
    }

    @objc
    private func saveBarButtonTap() {

    }

    private func setViews() {
        navigationItem.rightBarButtonItem = saveBarButton
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setConfigurations() {
        view.backgroundColor = .white
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        scrollView.showsHorizontalScrollIndicator = false
    }
}
