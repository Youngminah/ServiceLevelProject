//
//  SesacCell.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import UIKit
import RxSwift

final class SesacCell: UICollectionViewCell {

    static let identifier = "SesacCell"

    private let imageView = UIImageView()
    private let titleLabel = DefaultLabel(font: .title2R16, textColor: .black)
    private let contentLabel = DefaultLabel(font: .body3R14, textColor: .black)
    let priceButton = PriceButton()

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
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
        contentView.addSubview(priceButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.right.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalTo(priceButton.snp.left).offset(8)
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
        titleLabel.textAlignment = .left
        contentLabel.textAlignment = .natural
    }

    func updateUI(sesac: SesacImageCase, isHaving: Int) {
        imageView.image = sesac.image
        titleLabel.text = sesac.name
        contentLabel.text = sesac.content
        if isHaving == 1 {
            priceButton.setDefault()
        } else {
            priceButton.setNotHaving(text: sesac.price)
        }
    }
}
