//
//  GenderFilterView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa

final class GenderFilterView: UIView {

    private let stackView = UIStackView()
    private let totalButton = FilterButton(title: "전체")
    private let manButton = FilterButton(title: "남자")
    private let womanButton = FilterButton(title: "여자")

    let genderRelay = BehaviorRelay(value: GenderCase.total)

    private let disposedBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigurations()
        bind()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
    }

    private func bind() {
        Observable.merge(
            totalButton.rx.tap.map { GenderCase.total },
            womanButton.rx.tap.map { GenderCase.woman },
            manButton.rx.tap.map { GenderCase.man }
        )
        .bind(to: genderRelay)
        .disposed(by: disposedBag)

        genderRelay.map { $0 == .total }
            .bind(to: totalButton.rx.isSelected)
            .disposed(by: disposedBag)

        genderRelay.map { $0 == .woman }
            .bind(to: womanButton.rx.isSelected)
            .disposed(by: disposedBag)

        genderRelay.map { $0 == .man }
            .bind(to: manButton.rx.isSelected)
            .disposed(by: disposedBag)
    }

    private func setConfigurations() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [totalButton, manButton, womanButton].forEach { button in
            stackView.addArrangedSubview(button)
        }
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 8
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        addShadow(radius: 3)
        totalButton.isSelected = true
    }
}
