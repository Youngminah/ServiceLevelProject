//
//  MyGenderView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/30.
//

import UIKit
import RxSwift
import RxCocoa

final class MyGenderView: UIView {

    private let titleLabel = DefaultLabel(title: "내 성별", font: .title4R14)
    private let manButton = SelectionButton(title: "남자")
    private let womanButton = SelectionButton(title: "여자")

    private let disposdBag = DisposeBag()

    var getGender: GenderCase {
        if manButton.isSelected { return .man }
        if womanButton.isSelected { return .woman }
        return .total
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfigurations()
        bind()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
    }

    private func bind() {
        manButton.rx.tap.asDriver()
            .map { [weak self] in
                guard let self = self else { return false }
                if self.manButton.isSelected { return self.manButton.isSelected }
                self.womanButton.isSelected = false
                return !self.manButton.isSelected
            }
            .drive(manButton.rx.isSelected)
            .disposed(by: disposdBag)

        womanButton.rx.tap.asDriver()
            .map { [weak self] in
                guard let self = self else { return false }
                if self.womanButton.isSelected { return self.womanButton.isSelected }
                self.manButton.isSelected = false
                return !self.womanButton.isSelected
            }
            .drive(womanButton.rx.isSelected)
            .disposed(by: disposdBag)
    }

    func setGender(gender: GenderCase) {
        if gender == .woman {
            self.womanButton.isSelected = true
        } else if gender == .man {
            self.manButton.isSelected = true
        }
    }

    private func setConstraints() {
        addSubview(manButton)
        addSubview(womanButton)
        addSubview(titleLabel)
        manButton.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(48)
        }
        womanButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(manButton.snp.left).offset(-8)
            make.width.equalTo(56)
            make.height.equalTo(48)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(womanButton.snp.left).offset(-16)
        }
    }

    private func setConfigurations() {
        titleLabel.textAlignment = .left
    }
}
