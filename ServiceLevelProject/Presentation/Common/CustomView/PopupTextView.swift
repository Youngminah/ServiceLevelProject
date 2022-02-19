//
//  PopupTextView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/19.
//

import UIKit.UITextView

final class PopupTextView: UITextView, UITextViewDelegate {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setConfiguration()
    }

    var placeHolderText: String = "메세지를 입력하세요"

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    convenience init(placeHolder text: String) {
        self.init()
        placeHolderText = text
        self.placeholderSetting()
    }

    required init?(coder: NSCoder) {
        fatalError("PopupTextView: fatal Error")
    }

    private func setConfiguration() {
        delegate = self
        textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        backgroundColor = .gray1
        layer.cornerRadius = 8
        font = .body3R14
    }

    func placeholderSetting() {
        self.text = placeHolderText
        textColor = .gray7
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray7 {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholderSetting()
        }
    }
}
