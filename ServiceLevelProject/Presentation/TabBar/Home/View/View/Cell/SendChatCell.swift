//
//  ReceivedChatCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/15.
//

import UIKit

final class SendChatCell: BaseTableViewCell {

    static let identifier = "SendChatCell"

    private let textView = UITextView()
    private let dateLabel = DefaultLabel(font: .title5R12, textColor: .gray6) //폰트 바꾸기
    private let unReadLabel = DefaultLabel(title: "안읽음", font: .captionR10, textColor: .green)
    
    override func setView() {
        super.setView()
        contentView.addSubview(textView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(unReadLabel)
    }

    override func setConstraints() {
        super.setConstraints()
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.604)
            make.bottom.equalToSuperview().offset(-16).priority(.low)
        }
        dateLabel.snp.makeConstraints { make in
            make.right.equalTo(textView.snp.left).offset(-8)
            make.bottom.equalTo(textView.snp.bottom)
        }
        unReadLabel.snp.makeConstraints { make in
            make.bottom.equalTo(dateLabel.snp.top).offset(-2)
            make.right.equalTo(textView.snp.left).offset(-8)
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        textView.layer.cornerRadius = 8
        textView.font = .body3R14
        textView.textColor = .black
        textView.backgroundColor = .whiteGreen
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        [dateLabel, unReadLabel].forEach { $0.textAlignment = .right }
        unReadLabel.isHidden = true
    }

    func updateUI(chat: Chat) {
        textView.text = chat.text
        dateLabel.text = chat.createdAt.toString
        textView.sizeToFit()
    }
}
