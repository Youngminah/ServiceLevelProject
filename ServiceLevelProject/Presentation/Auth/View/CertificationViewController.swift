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

    private lazy var input = CertificationViewModel.Input(
        requestRegisterSignal: requestRegisterSignal.asSignal(),
        didLimitText: authNumberTextField.rx.text.orEmpty.asDriver(),
        didLimitTime: didLimitTime.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private var viewModel: CertificationViewModel

    private let requestRegisterSignal = PublishRelay<Void>()
    private let didLimitTime = PublishRelay<Void>()
    private let disposdBag = DisposeBag()

    private var verifyID: String
    private let totalTime = 60
    private lazy var limitTime = totalTime
    private lazy var totalTimeString = StopWatchConverterService(totalSeconds: totalTime).simpleTimeString

    private var timerDisposable: Disposable?

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
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authNumberTextField.setBorderLine()
        showToast(message: "인증번호를 보냈습니다.")
        startTimerRefresh()
    }

    private func bind() {
        output.showToastAction
            .emit(onNext: { [weak self] message in
                self?.showToast(message: message)
            })
            .disposed(by: disposdBag)

        output.isValidState
            .drive(startButton.rx.isValid)
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
        transferButton.addTarget(self, action: #selector(transferButtonTap), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startButtonTap), for: .touchUpInside)
        timeLimitLabel.font = .title3M14
        timeLimitLabel.textColor = .green
        timeLimitLabel.text = totalTimeString
        authNumberTextField.keyboardType = .numberPad
        authNumberTextField.textContentType = .oneTimeCode
        transferButton.isValid = true
    }

    @objc
    private func transferButtonTap() {
        limitTime = totalTime
        timeLimitLabel.text = totalTimeString
        showToast(message: "재전송 되었습니다.")
        startTimerRefresh()
    }

    @objc
    private func startButtonTap() {
        if limitTime > 0 &&
            startButton.isValid &&
            authNumberTextField.text!.isValidCertificationNumber() {
            signInFirebase()
            return
        }
        showToast(message: "전화번호 인증 실패")
    }

    private func signInFirebase() {
        let verificationCode = authNumberTextField.text!
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verifyID,
            verificationCode: verificationCode
        )
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            guard let self = self else { return }
            if let error = error {
                let authError = error as NSError
                self.showToast(message: authError.localizedDescription)
                return
            }
            self.getFirebaseIdtoken()
        }
    }

    private func getFirebaseIdtoken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return;
            }
            print(idToken! + "이거")
            UserDefaults.standard.setValue(idToken!, forKey: "IdToken")
            // Send token to your backend via HTTPS
            // ...
            self.timerDisposable?.dispose()
            self.requestRegisterSignal.accept(())
            print("완료!")
        }
    }

    private func startTimerRefresh() {
        timerDisposable?.dispose()
        timerDisposable = Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.totalTime - ($0 + 1)
            }.do(onNext: { [weak self] time in
                self?.limitTime = time
                if time == 0 {
                    self?.didLimitTime.accept(())
                }
            })
            .filter{ $0 < 0 ? false : true }
            .map { StopWatchConverterService(totalSeconds: $0).simpleTimeString }
            .bind(to: timeLimitLabel.rx.text)
    }

    private func showToast(message: String) {
        self.makeToastStyle()
        self.view.makeToast(message, position: .top)
    }
}
