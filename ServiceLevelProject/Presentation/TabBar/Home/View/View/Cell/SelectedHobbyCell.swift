//
//  SelectedHobbyCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import UIKit

class SelectedHobbyCell: UICollectionViewCell {

    static let identifier = "SelectedHobbyCell"

    private let hobbyButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraint() {
        addSubview(hobbyButton)
        hobbyButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func updateUI(hobbyInfo: Hobby) {
        hobbyButton.setTitle(hobbyInfo.content, for: .normal)
    }
}
