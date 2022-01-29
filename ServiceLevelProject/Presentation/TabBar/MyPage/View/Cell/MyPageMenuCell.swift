//
//  MyPageCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/28.
//

import UIKit

import SnapKit

final class MyPageMenuCell: BaseTableViewCell {

    static let identifier = "MyPageMenuCell"
    static let height: CGFloat = 74

    private let contentImageView = UIImageView()
    private let contentLabel = DefaultLabel(font: .title2R16)

    override func setView() {
        super.setView()
        contentView.addSubview(contentImageView)
        contentView.addSubview(contentLabel)
    }

    override func setConstraints() {
        super.setConstraints()
        contentImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalTo(contentImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
    }

    func updateUI(menu: MyPageMenuCase) {
        contentImageView.image = UIImage(named: menu.imageName)
        contentLabel.text = menu.title
    }
}
