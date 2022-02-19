//
//  PaddingLabel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/16.
//

import UIKit.UILabel

final class PaddingLabel: UILabel {

    private var padding = UIEdgeInsets(top: 5.0, left: 16.0, bottom: 5.0, right: 16.0)

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("NearHobbyLabel: fatal Error Message")
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
}
