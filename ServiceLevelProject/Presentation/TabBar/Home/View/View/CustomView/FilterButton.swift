//
//  FilterButton.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/04.
//

import UIKit.UIButton

final class FilterButton: UIButton {

    override var isSelected: Bool {
        didSet {
            isSelected ? setValidStatus(status: .fill) : setValidStatus(status: .inactive)
        }
    }

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
        setConfiguration()
        isSelected = false
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
        titleLabel?.font = .body3R14
    }

    func setValidStatus(status: ButtonStatus) {
        backgroundColor = status.backgroundColor
        setTitleColor(status.titleColor, for: .normal)
    }
}
