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
    let toggleButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfigurations()
    }

//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        textView.text = "asdd아면아ㅓㄴ이라ㅓㅁ니아러"
//        textView.sizeToFit()
//    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //setText(text: "안녕?하세영")
    }

    required init(coder: NSCoder) {
        fatalError("SesacReviewView: fatal error")
    }

    private func setConstraints() {
        addSubview(toggleButton)
        addSubview(titleLabel)
        addSubview(textView)
        toggleButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.height.width.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(toggleButton.snp.left).offset(-16)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func setConfigurations() {
        toggleButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        toggleButton.tintColor = .gray5
        textView.textColor = .gray6
        textView.isScrollEnabled = false
        textView.text = "첫 리뷰를 기다리는 중입니다."
        textView.sizeToFit()
        textView.isEditable = false
        titleLabel.textAlignment = .left
    }

    func setText(text: String) {
        textView.textColor = .label
        textView.text = text
        textView.sizeToFit()
    }

    func setPlaceHolder() {
        textView.textColor = .gray6
        textView.text = "첫 리뷰를 기다리는 중입니다."
        textView.sizeToFit()
    }
}
