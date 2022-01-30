//
//  LoginViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Toast

final class LoginViewController: UIViewController {

    private let descriptionLabel = DefaultLabel(title: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요",
                                                font: .display1R20)
    private let phoneNumberTextField = DefaultTextField(placeHolder: "휴대폰 번호(-없이 숫자만 입력)")
    private let confirmButton = DefaultButton(title: "인증 문자 받기")

    private lazy var input = LoginViewModel.Input(
        didLimitTextChange: phoneNumberTextField.rx.limitPhoneNumberText.asDriver(onErrorJustReturn: ""),
        didTextFieldBegin: phoneNumberTextField.rx.controlEvent(.editingDidBegin).asSignal(),
        didTextFieldEnd: phoneNumberTextField.rx.controlEvent(.editingDidEnd).asSignal(),
        verifyPhoneNumber: verifyPhoneNumber.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposdBag = DisposeBag()
    private let verifyPhoneNumber = PublishRelay<String>()
    private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("LoginViewController fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneNumberTextField.setBorderLine()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func bind() {
        output.phoneNumberText
            .emit(to: phoneNumberTextField.rx.text)
            .disposed(by: disposdBag)

        output.isValidState
            .drive(confirmButton.rx.isValid)
            .disposed(by: disposdBag)

        output.phoneNumberRemoveHiponAction
            .emit(onNext: { [unowned self] in
                self.phoneNumberTextField.text = self.phoneNumberTextField.text?.removeHipon()
            })
            .disposed(by: disposdBag)

        output.phoneNumberAddHiponAction
            .emit (onNext: { [unowned self] in
                self.phoneNumberTextField.text = self.phoneNumberTextField.text?.addHipon()
            })
            .disposed(by: disposdBag)

        output.showToastAction
            .emit(onNext: { [unowned self] message in
                self.makeToastStyle()
                self.view.makeToast(message, position: .top)
            })
            .disposed(by: disposdBag)

        output.indicatorAction
            .drive(onNext: {
                $0 ? IndicatorView.shared.show(backgoundColor: Asset.transparent.color) : IndicatorView.shared.hide()
            })
            .disposed(by: disposdBag)
    }
    
    private func setViews() {
        view.addSubview(descriptionLabel)
        view.addSubview(phoneNumberTextField)
        view.addSubview(confirmButton)
    }
    
    private func setConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
    
    private func setConfigurations() {
        view.backgroundColor = .white
        phoneNumberTextField.keyboardType = .numberPad
        confirmButton.addTarget(self, action: #selector(confirmButtonTap), for: .touchUpInside)
    }

    @objc
    private func confirmButtonTap() {
        let phoneNumber = (phoneNumberTextField.text?.removeHipon())!
        if !phoneNumber.isValidPhoneNumber() {
            self.makeToastStyle()
            self.view.makeToast(AuthError.inValidPhoneNumberFormat.errorDescription,
                                position: .top)
            return
        }
        verifyPhoneNumber.accept(phoneNumber)
    }
}
