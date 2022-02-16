//
//  InputTextView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/16.
//

import UIKit.UITextView

final class InputTextView: UITextView, UITextViewDelegate {

    let maxHeight: CGFloat = 75.0

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setConfiguration()
        self.placeholderSetting()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.height > maxHeight {
            size.height = maxHeight
            isScrollEnabled = true
        } else {
            isScrollEnabled = false
        }
        return size
    }

    override var text: String? {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("InputTextView: fatal Error")
    }

    private func setConfiguration() {
        delegate = self
        textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 44)
        backgroundColor = .gray1
        layer.cornerRadius = 8
        font = .body3R14
    }

    func placeholderSetting() {
        text = "메세지를 입력하세요"
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
            textView.text = "메세지를 입력하세요"
            textView.textColor = .gray7
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        invalidateIntrinsicContentSize()
    }
}
