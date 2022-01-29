//
//  SesacReviewView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import UIKit
import SnapKit

final class SesacReviewView: UIView {

    private let titleLabel = DefaultLabel(title: "새싹 리뷰", font: .title4R14)
    private let textView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
    }

    private func setConstraints() {
        addSubview(titleLabel)
        addSubview(textView)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.bottom.right.equalToSuperview().offset(-16)
        }
    }

    private func setConfigurations() {
        textView.textColor = .gray6
        textView.text = "첫 리뷰를 기다리는 중입니다."
    }
}
