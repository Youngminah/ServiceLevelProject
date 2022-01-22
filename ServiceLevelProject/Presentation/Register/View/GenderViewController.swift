//
//  SetGenderViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit

class GenderViewController: UIViewController {

    private let descriptionLabel = DescriptionLabel(title: "성별을 선택해 주세요")
    private let detailLabel = DetailLabel(title: "새싹 찾기 기능을 이용하기 위해서 필요해요!")
    private let womanButton = GenderButton(gender: .woman)
    private let manButton = GenderButton(gender: .man)
    private let nextButton = DefaultFillButton(title: "다음")
    private lazy var stackView = UIStackView(arrangedSubviews: [manButton, womanButton])

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
    }

    private func setViews() {
        view.addSubview(descriptionLabel)
        view.addSubview(detailLabel)
        view.addSubview(stackView)
        view.addSubview(nextButton)
    }

    private func setConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(120)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }

    private func setConfigurations() {
        view.backgroundColor = .white
        stackView.spacing = 8
    }
}
