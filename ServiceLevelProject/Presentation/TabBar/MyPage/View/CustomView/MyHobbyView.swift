//
//  MyHobbyView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/30.
//

import UIKit

final class MyHobbyView: UIView {

    private let titleLabel = DefaultLabel(title: "자주 하는 취미", font: .title4R14)
    private let textField = DefaultTextField(placeHolder: "취미를 입력해주세요")

    var getHobby: String? {
        return textField.text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfigurations()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
    }

    private func setConstraints() {
        addSubview(textField)
        addSubview(titleLabel)
        textField.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(160)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(textField.snp.left).offset(-16)
        }
    }

    private func setConfigurations() {
        titleLabel.textAlignment = .left
    }
}
