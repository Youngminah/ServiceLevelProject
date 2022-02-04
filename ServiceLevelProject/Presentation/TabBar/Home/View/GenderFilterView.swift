//
//  GenderFilterView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa

final class GenderFilterView: UIStackView {

    private let totalButton = SelectionButton(title: "전체")
    private let manButton = SelectionButton(title: "남자")
    private let womanButton = SelectionButton(title: "여자")

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
        [totalButton, manButton, womanButton].forEach { button in
            addArrangedSubview(button)
            button.layer.cornerRadius = 0
        }
        layer.masksToBounds = true
        layer.cornerRadius = 8
        distribution = .fillEqually
        axis = .vertical
    }
}
