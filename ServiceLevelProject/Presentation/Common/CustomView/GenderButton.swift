//
//  womanButton.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit.UIButton

enum Gender {
    case woman
    case man
}

final class GenderButton: UIButton {

    private var gender: Gender?

    override var isSelected: Bool {
        didSet {
            if #available(iOS 15.0, *) {
                configuration?.baseBackgroundColor = isSelected ? .whiteGreen : .white
            } else {
                backgroundColor = isSelected ? .whiteGreen : .white
            }
        }
    }

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
    }

    convenience init(gender: Gender) {
        self.init()
        self.gender = gender
        self.setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("DefaultFillButton: fatal Error Message")
    }

    private func setConfiguration() {
        layer.masksToBounds = true
        gender == .woman ? setWomanConfiguration() : setManConfiguration()
    }

    private func setWomanConfiguration() {
        if #available(iOS 15.0, *) {
            layer.masksToBounds = true
            layer.cornerRadius = 7
            layer.borderWidth = 1
            layer.borderColor = UIColor.gray3.cgColor
            configuration = .genderStyle(title: "여자", imageName: "woman")
        } else {
            setImage(Asset.womanButton.image, for: .normal)
            layer.cornerRadius = 7
            backgroundColor = .white
        }
    }

    private func setManConfiguration() {
        if #available(iOS 15.0, *) {
            layer.masksToBounds = true
            layer.cornerRadius = 7
            layer.borderWidth = 1
            layer.borderColor = UIColor.gray3.cgColor
            configuration = .genderStyle(title: "남자", imageName: "man")
        } else {
            setImage(Asset.manButton.image, for: .normal)
            layer.cornerRadius = 7
            backgroundColor = .white
        }
    }
}
