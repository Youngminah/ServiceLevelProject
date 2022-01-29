//
//  SesacPreviewView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import UIKit

final class SesacPreviewView: UIView {

    private let nickNameLabel = DefaultLabel(font: .title1M16)
    private let toggleButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
    }

    private func setConstraints() {
        addSubview(toggleButton)
        addSubview(nickNameLabel)
        toggleButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.right.equalToSuperview().offset(-16)
            make.width.equalTo(toggleButton.snp.width)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.right.equalTo(toggleButton.snp.left).offset(-16)
        }
    }

    private func setConfigurations() {
        toggleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        toggleButton.tintColor = .gray5
    }
}
