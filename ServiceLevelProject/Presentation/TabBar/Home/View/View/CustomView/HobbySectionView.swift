//
//  HobbySectionView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import UIKit

class HobbySectionView: UICollectionReusableView {

    static let identifier = "HobbySectionView"
    //폰트 추가
    private let titleLabel = DefaultLabel(font: .title5R12, textColor: .black)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraint()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
    }

    private func setConstraint() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.right.bottom.left.equalToSuperview()
            make.height.equalTo(40)
        }
        titleLabel.textAlignment = .left
    }

    func setTitle(text: String) {
        self.titleLabel.text = text
    }
}
