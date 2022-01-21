//
//  DetailLabel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit.UILabel

final class DetailLabel: UILabel {

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        self.setConfiguration()
    }

    convenience init(title text: String) {
        self.init()
        self.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("DefaultFillButton: fatal Error Message")
    }

    private func setConfiguration() {
        textAlignment = .center
        font = .title2R16
        textColor = .gray7
        numberOfLines = 0
    }
}
