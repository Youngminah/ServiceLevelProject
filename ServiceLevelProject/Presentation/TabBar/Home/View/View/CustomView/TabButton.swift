//
//  TabButton.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/11.
//

import UIKit.UIButton

class TabButton: UIButton {

    override var isSelected: Bool {
        didSet {
            isSelected ? setTitleColor(.green, for: .normal) : setTitleColor(.gray6, for: .normal)
        }
    }

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        setConfiguration()
    }

    convenience init(title text: String, isSelected: Bool = false) {
        self.init()
        self.setTitle(text, for: .normal)
        self.isSelected = isSelected
    }

    required init?(coder: NSCoder) {
        fatalError("DefaultFillButton: fatal Error Message")
    }

    func setConfiguration() {
        titleLabel?.font = .title3M14
    }
}
