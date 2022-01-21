//
//  SetEmailViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit

final class SetEmailViewController: UIViewController {

    private let descriptionLabel = DescriptionLabel(title: "이메일을 입력해 주세요")
    private let detailLabel = DetailLabel(title: "휴대폰 번호 변경 시 인증을 위해 사용해요")
    private let emailTextField = AuthTextField(placeHolder: "SeSAC@email.com")
    private let nextButton = DefaultFillButton(title: "다음")

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.setBorderLine()
    }

    private func setViews() {
        view.addSubview(descriptionLabel)
        view.addSubview(detailLabel)
        view.addSubview(emailTextField)
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
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(76)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(84)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }

    private func setConfigurations() {
        view.backgroundColor = .white
    }
}
