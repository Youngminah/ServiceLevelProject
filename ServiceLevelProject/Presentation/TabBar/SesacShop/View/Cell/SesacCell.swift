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
    private let priceLabel = DefaultLabel(font: .title5M12, textColor: .white)
    
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
        contentView.addSubview(priceLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.right.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalTo(priceLabel.snp.left).offset(8)
            make.height.equalTo(26)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }

    private func setConfiguration() {
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray4.cgColor
        imageView.layer.cornerRadius = 8
        priceLabel.backgroundColor = .green
        priceLabel.layer.cornerRadius = 8
        priceLabel.layer.masksToBounds = true
        titleLabel.textAlignment = .left
        contentLabel.textAlignment = .natural
    }

    func updateUI(sesac: SesacImageCase) {
        imageView.image = sesac.image
        titleLabel.text = sesac.name
        contentLabel.text = sesac.content
        priceLabel.text = sesac.price
        if sesac.price == "보유" {
            priceLabel.backgroundColor = .gray2
            priceLabel.textColor = .gray7
        }
    }
}
