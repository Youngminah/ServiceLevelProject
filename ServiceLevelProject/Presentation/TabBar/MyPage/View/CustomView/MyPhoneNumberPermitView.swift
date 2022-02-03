//
//  MyPhoneNumberPermitView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/30.
//

import UIKit

final class MyPhoneNumberPermitView: UIView {

    private let titleLabel = DefaultLabel(title: "내 번호 검색 허용", font: .title4R14)
    private let toggleSwitch = UISwitch()

    var toggleSwitchIsOn: Bool {
        return toggleSwitch.isOn
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfigurations()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
    }

    func setSwitch(isOn: Bool) {
        toggleSwitch.isOn = isOn
    }

    private func setConstraints() {
        addSubview(toggleSwitch)
        addSubview(titleLabel)
        toggleSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(toggleSwitch.snp.left).offset(-16)
        }
    }

    private func setConfigurations() {
        titleLabel.textAlignment = .left
        toggleSwitch.onTintColor = .green
    }
}
