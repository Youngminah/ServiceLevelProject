//
//  HobbyCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import UIKit
import SnapKit

class NearHobbyCell: UICollectionViewCell {

    static let identifier = "NearHobbyCell"

    private var hobbyLabel = NearHobbyLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraint()
        hobbyLabel.isFixed = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraint() {
        contentView.addSubview(hobbyLabel)
        hobbyLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.right.equalToSuperview().priority(999)
        }
    }

    func updateUI(item: HomeSearchItemViewModel) {
        hobbyLabel.text = item.content
        hobbyLabel.isFixed = item.isRecommended
    }
}
