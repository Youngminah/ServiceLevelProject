//
//  SelectedHobbyCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import UIKit

class SelectedHobbyCell: UICollectionViewCell {

    static let identifier = "SelectedHobbyCell"

    private let borderView = UIView()
    private let hobbyLabel = DefaultLabel(font: .title4R14, textColor: .green)
    private let cancelButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraint()
        setConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraint() {
        contentView.addSubview(borderView)
        borderView.addSubview(cancelButton)
        borderView.addSubview(hobbyLabel)
        borderView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.right.equalToSuperview().priority(999)
        }
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(16)
        }
        hobbyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalTo(cancelButton.snp.left).offset(-6)
        }
    }

    private func setConfiguration() {
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.green.cgColor
        borderView.layer.cornerRadius = 8
        cancelButton.setImage(Asset.xmark.image, for: .normal)
        cancelButton.tintColor = .green
    }

    func updateUI(hobbyInfo: Hobby) {
        hobbyLabel.text = hobbyInfo.content
    }
}
