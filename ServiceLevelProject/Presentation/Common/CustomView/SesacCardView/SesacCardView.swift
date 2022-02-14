//
//  SesacCardView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/14.
//

import UIKit
import SnapKit

final class SesacCardView: UIView {

    let previewView = SesacPreviewView()
    private let sesacTitleView = SesacTitleView()
    let sesacHobbyView = SesacHobbyView()
    let sesacReviewView = SesacReviewView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("SesacCardView: fatal error")
    }

    private func setConstraints() {
        addSubview(previewView)
        addSubview(sesacTitleView)
        addSubview(sesacHobbyView)
        addSubview(sesacReviewView)
        previewView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        sesacTitleView.snp.makeConstraints { make in
            make.top.equalTo(previewView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(196)
        }
        sesacHobbyView.snp.makeConstraints { make in
            make.top.equalTo(sesacTitleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(sesacReviewView.snp.top).priority(.low)
        }
        sesacReviewView.snp.makeConstraints { make in
            make.top.equalTo(sesacHobbyView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
    }

    private func setConfiguration(){
        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderColor = UIColor.gray4.cgColor
        layer.borderWidth = 1
    }

    func setNickname(nickname text: String){
        previewView.setNickname(nickname: text)
    }

    func setReviewText(text: String) {
        sesacReviewView.setText(text: text)
    }

    func setPlaceHolder() {
        sesacReviewView.setPlaceHolder()
    }

    func setSesacTitle(reputation: [Int]) {
        sesacTitleView.setSesacTitle(reputation: reputation)
    }

    func setToggleButtonImage(isToggle: Bool) {
        previewView.setToggleButtonImage(isToggle: isToggle)
    }
}