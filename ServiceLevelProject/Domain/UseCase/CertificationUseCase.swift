//
//  CertificationUseCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import Foundation
import RxSwift

final class CertificationUseCase {

    private let userRepository: UserRepositoryType
    private let fireBaseRepository: FirbaseRepositoryType
    private let sesacRepository: SesacRepositoryType

    var failFirebaseFlowSignal = PublishSubject<FirbaseNetworkServiceError>()
    var successLogInSignal = PublishSubject<Void>()
    var unRegisteredUserSignal = PublishSubject<Void>()
    var unKnownErrorSignal = PublishSubject<Void>()
    var retransmitSuccessSignal = PublishSubject<String>()

    init(
        userRepository: UserRepositoryType,
        fireBaseRepository: FirbaseRepositoryType,
        sesacRepository: SesacRepositoryType
    ) {
        self.userRepository = userRepository
        self.fireBaseRepository = fireBaseRepository
        self.sesacRepository = sesacRepository
    }

    func requestSignIn(verifyID: String, code: String) {
        self.fireBaseRepository.signIn(verifyID: verifyID, certificationNumber: code) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success():
                self.requestIDToken()
            case .failure(let error):
                self.failFirebaseFlowSignal.onNext(error)
            }
        }
    }

    func retransferCertificationCode() {
        let phoneNumber = fetchPhoneNumber()!
        self.fireBaseRepository.verifyPhoneNumber(phoneNumber: phoneNumber) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let verifyID):
                self.retransmitSuccessSignal.onNext(verifyID)
            case .failure(let error):
                print(error.errorDescription)
                self.failFirebaseFlowSignal.onNext(error)
            }
        }
    }

    private func requestIDToken() {
        self.fireBaseRepository.requestIdtoken { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let idToken):
                print("\(idToken)")
                self.userRepository.saveIdTokenInfo(idToken: idToken)
                self.requestUserInfo()
            case .failure(let error):
                self.failFirebaseFlowSignal.onNext(error)
            }
        }
    }

    private func requestUserInfo() {
        self.sesacRepository.requestUserInfo { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(_):
                self.saveLogInInfo()
                self.successLogInSignal.onNext(())
            case .failure(let error):
                if error.rawValue == 406 {
                    self.unRegisteredUserSignal.onNext(())
                } else {
                    self.unKnownErrorSignal.onNext(())
                }
            }
        }
    }

    private func fetchPhoneNumber() -> String? {
        return self.userRepository.fetchPhoneNumber()
    }

    private func saveLogInInfo() {
        self.userRepository.saveLogInInfo()
    }
}
