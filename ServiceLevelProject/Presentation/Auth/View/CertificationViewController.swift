//
//  CertificationViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/18.
//

import UIKit
import FirebaseAuth
import RxCocoa
import RxSwift

final class CertificationViewController: UIViewController {
    
    private let descriptionLabel = DescriptionLabel(title: "인증번호가 문자로 전송되었어요")
    private let timeLimitLabel = UILabel()
    private let authNumberTextField = AuthTextField(placeHolder: "인증번호 입력")
    private let transferButton = DefaultFillButton(title: "재전송")
    private let startButton = DefaultFillButton(title: "인증하고 시작하기")

    private let disposdBag = DisposeBag()
    private let totalTime = 5
    private var viewModel: CertificationViewModel
    private var verifyID: String

    init(viewModel: CertificationViewModel, verifyID: String) {
        self.viewModel = viewModel
        self.verifyID = verifyID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("CertificationVC fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authNumberTextField.setBorderLine()
        showToast(message: "인증번호를 보냈습니다.")
        bind()
    }

    private func bind() {
        Observable<Int>
                    .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                    .map { [unowned self] seconds in
                        self.totalTime - (1 + seconds)
                    }
                    .filter({ time in
                        return time < 0 ? false : true
                    })
                    .map {
                        StopWatch(totalSeconds: $0).simpleTimeString
                    }
                    .bind(to: timeLimitLabel.rx.text)
                    .disposed(by: disposdBag)
    }
    
    private func setViews() {
        view.addSubview(descriptionLabel)
        view.addSubview(transferButton)
        view.addSubview(authNumberTextField)
        view.addSubview(startButton)
        view.addSubview(timeLimitLabel)
    }
    
    private func setConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        transferButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(77)
            make.width.equalTo(72)
            make.height.equalTo(40)
            make.trailing.equalToSuperview().offset(-16)
        }
        authNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(77)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(transferButton.snp.left).offset(-8)
            make.height.equalTo(40)
        }
        startButton.snp.makeConstraints { make in
            make.top.equalTo(authNumberTextField.snp.bottom).offset(84)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        timeLimitLabel.snp.makeConstraints { make in
            make.right.equalTo(authNumberTextField.snp.right).offset(-20)
            make.width.equalTo(37)
            make.centerY.equalTo(authNumberTextField.snp.centerY)
        }
    }
    
    private func setConfigurations() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        startButton.addTarget(self, action: #selector(startButtonTap), for: .touchUpInside)
        timeLimitLabel.font = .title3M14
        timeLimitLabel.textColor = .green
        timeLimitLabel.text = "05:00"
        authNumberTextField.keyboardType = .numberPad
        authNumberTextField.textContentType = .oneTimeCode
        transferButton.isValid = true
    }

    @objc
    private func startButtonTap() {
        let verificationCode = "675005"
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyID, verificationCode: verificationCode)

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                print(authError.description)
                return
            }
            // User has signed in successfully and currentUser object is valid
            let currentUserInstance = Auth.auth().currentUser
            print(currentUserInstance)
        }
    }

    private func showToast(message: String) {
        self.makeToastStyle()
        self.view.makeToast(message, position: .top)
    }
}
