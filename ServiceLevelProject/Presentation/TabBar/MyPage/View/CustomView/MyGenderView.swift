//
//  MyGenderView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/30.
//

import UIKit

final class MyGenderView: UIView {

    private let titleLabel = DefaultLabel(title: "내 성별", font: .title4R14)
    private let manButton = SelectionButton(title: "남자")
    private let womanButton = SelectionButton(title: "여자")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfigurations()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
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
