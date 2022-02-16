//
//  SendChatCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/15.
//

import UIKit

final class ReceivedChatCell: BaseTableViewCell {

    static let identifier = "ReceivedChatCell"

    private let textView = UITextView()
    private let dateLabel = DefaultLabel(font: .title5R12, textColor: .gray6) //폰트 바꾸기

    override func setView() {
        super.setView()
        contentView.addSubview(textView)
        contentView.addSubview(dateLabel)
    }

    override func setConstraints() {
        super.setConstraints()
        textView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.604)
            make.bottom.equalToSuperview().offset(-16).priority(.low)
        }
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(textView.snp.right).offset(8)
            make.right.equalToSuperview()
            make.bottom.equalTo(textView.snp.bottom)
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray5.cgColor
        textView.font = .body3R14
        textView.textColor = .black
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        dateLabel.textAlignment = .left
        //temp
        textView.text = "안녕하세요 자전거 언제 타실 생각이세요?"
        dateLabel.text = "15:02"
    }

    func updateUI(chat: Chat) {
        textView.text = chat.text
        dateLabel.text = chat.createdAt.toString
    }
}
