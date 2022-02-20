//
//  BackgroundCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import UIKit

final class BackgroundCell: BaseTableViewCell {

    static let identifier = "BackgroundCell"

    private let sesacImageView = UIImageView()
    private let titleLabel = DefaultLabel(font: .title2R16, textColor: .black)
    private let contentLabel = DefaultLabel(font: .body3R14, textColor: .black)
    private let priceLabel = PaddingLabel()

    override func setView() {
        super.setView()
        contentView.addSubview(sesacImageView)
    }

    override func setConstraints() {
        super.setConstraints()
        sesacImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.height.width.equalToSuperview().multipliedBy(165.0 * (UIScreen.main.bounds.width - 32))
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
    }
}
