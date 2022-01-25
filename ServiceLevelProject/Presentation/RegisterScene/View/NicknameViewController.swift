//
//  SetNicknameViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit
import RxCocoa
import RxSwift
import Toast

final class NicknameViewController: UIViewController {

    private let descriptionLabel = DefaultLabel(title: "닉네임을 입력해 주세요", font: .display1R20)
    private let nicknameTextField = AuthTextField(placeHolder: "10자 이내로 입력")
    private let nextButton = DefaultFillButton(title: "다음")

    private lazy var input = NickNameViewModel.Input(
        didTextChange: nicknameTextField.rx.text.orEmpty.asSignal(onErrorJustReturn: ""),
        didNextButtonTap: nextButton.rx.tap
            .map { [unowned self] in
                return self.nicknameTextField.text!
            }
            .asSignal(onErrorJustReturn: "")
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposdBag = DisposeBag()
    private let didTextChange = PublishRelay<String>()
    private let didNextButtonTap = PublishRelay<String>()
    private var viewModel: NickNameViewModel

    init(viewModel: NickNameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("NickNameVC fatal error")
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
        nicknameTextField.setBorderLine()
    }

    private func bind() {
        output.showToastAction
            .emit(onNext: { [unowned self] text in
                self.makeToastStyle()
                self.view.makeToast(text, position: .top)
            })
            .disposed(by: disposdBag)

        output.isValidState
            .drive(nextButton.rx.isValid)
            .disposed(by: disposdBag)
    }

    private func setViews() {
        view.addSubview(descriptionLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
    }

    private func setConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }

    private func setConfigurations() {
        title = ""
        view.backgroundColor = .white
        nicknameTextField.becomeFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
