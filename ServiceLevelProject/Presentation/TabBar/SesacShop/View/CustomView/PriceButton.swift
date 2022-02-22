//
//  PriceButton.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/22.
//

import UIKit.UIButton

final class PriceButton: UIButton {

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("PriceButton: fatal Error Message")
    }

    private func setConfiguration() {
        layer.masksToBounds = true
        titleLabel?.font = .title5M12
        layer.cornerRadius = 8
        layer.masksToBounds = true
        setDefault()
    }

    func setDefault() {
        backgroundColor = .gray2
        setTitle("보유", for: .normal)
        setTitleColor(.gray7, for: .normal)
    }

    func setNotHaving(text: String) {
        backgroundColor = .green
        setTitle(text, for: .normal)
        setTitleColor(.white, for: .normal)
    }
}
