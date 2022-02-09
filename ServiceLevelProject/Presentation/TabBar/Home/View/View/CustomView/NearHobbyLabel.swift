//
//  NearHobbyLabel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import UIKit.UILabel
import UIKit

final class NearHobbyLabel: UILabel {

    private var padding = UIEdgeInsets(top: 5.0, left: 16.0, bottom: 5.0, right: 16.0)

    var isFixed: Bool = false {
        didSet {
            isFixed ? setHightlighted() : setOriginal()
        }
    }

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        self.setConfiguration()
        isFixed = false
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    required init?(coder: NSCoder) {
        fatalError("NearHobbyLabel: fatal Error Message")
    }

    private func setConfiguration() {
        font = .title4R14
        numberOfLines = 1
        textAlignment = .center
        layer.cornerRadius = 8
        layer.borderWidth = 1
    }

    private func setHightlighted() {
        textColor = .error
        layer.borderColor = UIColor.error.cgColor
    }

    private func setOriginal() {
        textColor = .black
        layer.borderColor = UIColor.gray3.cgColor
    }
}
