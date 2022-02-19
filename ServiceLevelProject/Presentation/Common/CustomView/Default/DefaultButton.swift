//
//  DefaultButton.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/18.
//

import UIKit.UIButton

class DefaultButton: UIButton {
    
    var isValid: Bool = false {
        didSet {
            isValid ? setValidStatus(status: .fill) : setValidStatus(status: .disable)
        }
    }

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        setConfiguration()
    }
    
    convenience init(title text: String) {
        self.init()
        setTitle(text, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("DefaultFillButton: fatal Error Message")
    }
    
    func setConfiguration() {
        layer.masksToBounds = true
        layer.cornerRadius = 8
        titleLabel?.font = .body3R14
    }

    func setValidStatus(status: ButtonStatus) {
        layer.borderWidth = 1
        layer.borderColor = status.borderColor
        backgroundColor = status.backgroundColor
        setTitleColor(status.titleColor, for: .normal)
    }
}
