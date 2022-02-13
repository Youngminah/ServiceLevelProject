//
//  ReviewCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/14.
//

import UIKit

class ReviewCell: BaseTableViewCell {

    static let identifier = "ReviewCell"
    private let textView = UITextView()

    override func setView() {
        super.setView()
        contentView.addSubview(textView)
    }

    override func setConstraints() {
        super.setConstraints()
        textView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16).priority(.low)
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        textView.isScrollEnabled = false
        textView.font = .body3R14
        textView.textColor = .black
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func updateUI(review text: String) {
        textView.text = text
        textView.sizeToFit()
    }
}
