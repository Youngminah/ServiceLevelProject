//
//  BackgroundCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import UIKit
import RxSwift

final class BackgroundCell: BaseTableViewCell {

    static let identifier = "BackgroundCell"

    private let sesacImageView = UIImageView()
    private let titleLabel = DefaultLabel(font: .title2R16, textColor: .black)
    private let contentLabel = DefaultLabel(font: .body3R14, textColor: .black)
    let priceButton = PriceButton()

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setView() {
        super.setView()
        contentView.addSubview(sesacImageView)
        contentView.addSubview(priceButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
    }

    override func setConstraints() {
        super.setConstraints()
        sesacImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(sesacImageView.snp.height)
        }
        priceButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceButton)
            make.left.equalTo(sesacImageView.snp.right).offset(16)
            make.right.equalTo(priceButton.snp.left).offset(-8)
            make.height.equalTo(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(sesacImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        contentView.isUserInteractionEnabled = true
        sesacImageView.contentMode = .scaleAspectFill
        sesacImageView.layer.cornerRadius = 8
        sesacImageView.layer.masksToBounds = true
        titleLabel.textAlignment = .left
        contentLabel.textAlignment = .natural
    }

    func updateUI(background: SesacBackgroundCase, isHaving: Int) {
        sesacImageView.image = background.image
        titleLabel.text = background.name
        contentLabel.text = background.content
        if isHaving == 1 {
            priceButton.setDefault()
        } else {
            priceButton.setNotHaving(text: background.price)
        }
    }
}
