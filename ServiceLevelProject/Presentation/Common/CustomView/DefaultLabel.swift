//
//  DescriptionLabel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/18.
//

import UIKit.UILabel

final class DefaultLabel: UILabel {

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        self.setConfiguration()
    }

    convenience init(title text: String, font: UIFont, textColor: UIColor = .label) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }

    required init?(coder: NSCoder) {
        fatalError("DefaultFillButton: fatal Error Message")
    }

    private func setConfiguration() {
        textAlignment = .center
        numberOfLines = 0
    }
}
