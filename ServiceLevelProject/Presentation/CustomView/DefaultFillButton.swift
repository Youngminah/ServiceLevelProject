//
//  DefaultButton.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/18.
//

import UIKit.UIButton

final class DefaultFillButton: UIButton {
    
    var isValid: Bool = false {
        didSet { backgroundColor = isValid ? .green : .gray6 }
    }

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        self.setConfiguration()
    }
    
    convenience init(title text: String) {
        self.init()
        setTitle(text, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("DefaultFillButton: fatal Error Message")
    }
    
    private func setConfiguration() {
        layer.masksToBounds = true
        layer.cornerRadius = 8
        titleLabel?.font = .body3R14
        backgroundColor = .gray6
    }
}
