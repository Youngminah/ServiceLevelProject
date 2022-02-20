//
//  SesacCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import UIKit

final class SesacCell: UICollectionViewCell {

    static let identifier = "SesacCell"

    private let imageView = UIImageView()
    private let titleLabel = DefaultLabel(font: .title2R16, textColor: .black)
    private let contentLabel = DefaultLabel(font: .body3R14, textColor: .black)
    private let priceLabel = PaddingLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraint()
        setConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraint() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
    }

    private func setConfiguration() {
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray4.cgColor
        imageView.layer.cornerRadius = 8
    }
}
