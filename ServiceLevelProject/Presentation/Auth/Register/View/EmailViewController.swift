//
//  SetEmailViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit
import RxCocoa
import RxSwift
import Toast
import SnapKit

final class EmailViewController: UIViewController {

    private let descriptionLabel = DefaultLabel(title: "이메일을 입력해 주세요",
                                                font: .display1R20)
    private let detailLabel = DefaultLabel(title: "휴대폰 번호 변경 시 인증을 위해 사용해요",
                                           font: .title2R16 ,
                                           textColor: .gray7)
    private let emailTextField = AuthTextField(placeHolder: "SeSAC@email.com")
    private let nextButton = DefaultFillButton(title: "다음")

    private lazy var input = EmailViewModel.Input(
        didTextChange: emailTextField.rx.text.orEmpty.asSignal(onErrorJustReturn: ""),
        didNextButtonTap: nextButton.rx.tap.withLatestFrom(emailTextField.rx.text.orEmpty)
            .asSignal(onErrorJustReturn: "")
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposdBag = DisposeBag()

    private var viewModel: EmailViewModel

    init(viewModel: EmailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("BirthViewController: fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.setBorderLine()
    }

    private func bind() {
        output.showToastAction
            .emit(onNext: { [unowned self] text in
                self.view.makeToast(text, position: .top)
            })
            .disposed(by: disposdBag)

        output.isValid
            .drive(nextButton.rx.isValid)
            .disposed(by: disposdBag)
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
        title = ""
        view.backgroundColor = .white
        emailTextField.becomeFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
