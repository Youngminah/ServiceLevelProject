//
//  CertificationViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/21.
//

import Foundation
import FirebaseAuth
import Moya
import RxCocoa
import RxSwift

final class CertificationViewModel: CommonViewModel, ViewModelType {

    private weak var coordinator: CertificationCoordinator?

    struct Input {
        let signInFirebaseSignal: Signal<String>
        let didLimitText: Driver<String>
        let didLimitTime: Signal<Void>
    }
    struct Output {
        let isValidState: Driver<Bool>
        let showToastAction: Signal<String>
        let disposeTimerAction: Signal<Void>
    }
    var disposeBag = DisposeBag()

    private let isValidState = BehaviorRelay<Bool>(value: false)
    private let showToastAction = PublishRelay<String>()
    private let disposeTimerAction = PublishRelay<Void>()

    private var verifyID: String

    init(verifyID: String, coordinator: CertificationCoordinator?) {
        self.verifyID = verifyID
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {

        input.didLimitText
            .map{ $0.count == 6 ? true : false }
            .distinctUntilChanged()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                $0 ? self.isValidState.accept(true) : self.isValidState.accept(false)
            })
            .disposed(by: disposeBag)

        input.didLimitTime
            .emit(onNext: { [weak self] text in
                guard let self = self else { return }
                self.showToastAction.accept("전화번호 인증 실패")
            })
            .disposed(by: disposeBag)

        input.signInFirebaseSignal
            .emit(onNext: { [weak self] code in
                guard let self = self else { return }
                self.signInFirebase(code: code)
            })
            .disposed(by: disposeBag)

        return Output(
            isValidState: isValidState.asDriver(),
            showToastAction: showToastAction.asSignal(),
            disposeTimerAction: disposeTimerAction.asSignal()
        )
    }
}

extension CertificationViewModel {

    private func signInFirebase(code: String) {
        let verificationCode = code
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verifyID,
            verificationCode: verificationCode
        )
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            guard let self = self else { return }
            if let error = error {
                let authError = error as NSError
                self.showToastAction.accept("\(authError.localizedDescription)")
                return
            }
            self.requestFirebaseIdtoken {
                self.disposeTimerAction.accept(())
                self.requestUserInfo { response in
                    switch response {
                    case .success(let response):
                        print("서버에서 준 코드!! \(response)")
                        // 홈화면 전환
                    case .failure(let error):
                        let errorCode = error.rawValue
                        // 닉네입화면 전환
                        fatalError(error.description)
                    }
                }
            }
        }
    }

    func requestUserInfo(completion: @escaping (Result<UserInfoResponse, DefaultMoyaNetworkServiceError>) -> Void) {
        provider.request(.getUserInfo) { result in
            self.process(type: UserInfoResponse.self, result: result, completion: completion)
        }
    }

    func requestRegister(completion: @escaping (Result<Int, Error>) -> Void ) {
        let userInfo = UserRegisterInfo(
            phoneNumber: "+821088407593",
            FCMtoken: UserDefaults.standard.string(forKey: "FCMToken")!,
            nick: "youngmin",
            birth: "1994-11-14T09:23:44.054Z",
            email: "youngminah@gmail.com",
            gender: 1
        )
        let parameters = userInfo.toDictionary

        provider.request(.register(parameters: parameters)) { result in
            self.process(
                result: result,
                completion: completion
            )
        }
    }
}
