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

    private let disposdBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigurations()
        bind()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
    }

    private func bind() {
        totalButton.rx.tap.asDriver()
            .map { [weak self] in
                guard let self = self else { return false }
                if self.totalButton.isSelected { return self.totalButton.isSelected }
                self.womanButton.isSelected = false
                self.manButton.isSelected = false
                return !self.totalButton.isSelected
            }
            .drive(totalButton.rx.isSelected)
            .disposed(by: disposdBag)

        manButton.rx.tap.asDriver()
            .map { [weak self] in
                guard let self = self else { return false }
                if self.manButton.isSelected { return self.manButton.isSelected }
                self.womanButton.isSelected = false
                self.totalButton.isSelected = false
                return !self.manButton.isSelected
            }
            .drive(manButton.rx.isSelected)
            .disposed(by: disposdBag)

        womanButton.rx.tap.asDriver()
            .map { [weak self] in
                guard let self = self else { return false }
                if self.womanButton.isSelected { return self.womanButton.isSelected }
                self.manButton.isSelected = false
                self.totalButton.isSelected = false
                return !self.womanButton.isSelected
            }
            .drive(womanButton.rx.isSelected)
            .disposed(by: disposdBag)
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
