//
//  AgeRangeView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/30.
//

import UIKit
import DoubleSlider

final class AgeRangeView: UIView {

    private let titleLabel = DefaultLabel(title: "상대방 연령대", font: .title4R14)
    private let rangeLabel = DefaultLabel(title: "18: 35", font: .title3M14)
    private let doubleSlider = DoubleSlider()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfigurations()
    }

    required init(coder: NSCoder) {
        fatalError("SesacTitleView: fatal error")
    }

    private func setConstraints() {
        addSubview(rangeLabel)
        addSubview(titleLabel)
        addSubview(doubleSlider)
        rangeLabel.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(80)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.right.equalTo(rangeLabel.snp.left).offset(-16)
            make.centerY.equalTo(rangeLabel.snp.centerY)
        }
        doubleSlider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(-20)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    private func setConfigurations() {
        titleLabel.textAlignment = .left
        rangeLabel.textColor = .green
        doubleSlider.thumbTintColor = .green
        doubleSlider.trackTintColor = .gray2
        doubleSlider.trackHighlightTintColor = .green
        doubleSlider.layerInset = 10
        doubleSlider.minLabel.isHidden = true
        doubleSlider.maxLabel.isHidden = true
    }
}
