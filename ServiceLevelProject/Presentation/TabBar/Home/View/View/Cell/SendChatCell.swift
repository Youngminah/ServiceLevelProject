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
            make.width.equalToSuperview().multipliedBy(0.604)
            make.bottom.equalToSuperview().offset(-16).priority(.low)
        }
        dateLabel.snp.makeConstraints { make in
            make.right.equalTo(textView.snp.left).offset(-8)
            make.left.equalToSuperview()
            make.bottom.equalTo(textView.snp.bottom)
        }
        unReadLabel.snp.makeConstraints { make in
            make.bottom.equalTo(dateLabel.snp.top).offset(-2)
            make.right.equalTo(textView.snp.left).offset(-8)
            make.left.equalToSuperview()
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
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        [dateLabel, unReadLabel].forEach { $0.textAlignment = .right }
        //temp
        textView.text = "안녕하세요! 저 평일은 저녁 8시에 꾸준히 타는데 7시부터 타도 괜찮아요"
        dateLabel.text = "15:02"
    }

    func updateUI(text: String) {
        textView.text = text
    }

    func updateUI(chat: Chat) {
        textView.text = chat.text
        dateLabel.text = chat.createdAt.toString
    }
}
