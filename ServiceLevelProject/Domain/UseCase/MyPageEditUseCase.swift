//
//  MyPageEditUseCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/31.
//

import Foundation
import RxSwift
import RxRelay

final class MyPageEditUseCase {

    private let userRepository: UserRepositoryType
    private let fireBaseRepository: FirbaseRepositoryType
    private let sesacRepository: SesacRepositoryType

    var successWithdrawSignal = PublishRelay<Void>()
    var failWithdrawSignal = PublishRelay<SesacNetworkServiceError>()
    var failFirebaseFlowSignal = PublishRelay<FirbaseNetworkServiceError>()

    init(
        userRepository: UserRepositoryType,
        fireBaseRepository: FirbaseRepositoryType,
        sesacRepository: SesacRepositoryType
    ) {
        self.userRepository = userRepository
        self.fireBaseRepository = fireBaseRepository
        self.sesacRepository = sesacRepository
    }

    func requestWithdraw() {
        sesacRepository.requestWithdraw() { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let code):
                print("성공 -->", code)
                self.withdrawUserInfo()
                self.successWithdrawSignal.accept(())
            case .failure(let error):
                print(error.description)
                switch error {
                case .alreadyWithdrawn:
                    self.withdrawUserInfo()
                    self.failWithdrawSignal.accept(error)
                case .inValidIDTokenError:
                    self.requestIDToken()
                default:
                    self.logoutUserInfo()
                    self.failWithdrawSignal.accept(error)
                }
            }
        }
    }

    private func requestIDToken() {
        fireBaseRepository.requestIdtoken { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let idToken):
                print("재발급 성공--> \(idToken)")
                self.saveIdTokenInfo(idToken: idToken)
                self.requestWithdraw()
            case .failure(let error):
                print(error.description)
                self.logoutUserInfo()
                self.failFirebaseFlowSignal.accept(error)
            }
        }
    }

    private func saveIdTokenInfo(idToken: String) {
        self.userRepository.saveIdTokenInfo(idToken: idToken)
    }

    private func withdrawUserInfo() {
        self.userRepository.withdrawUserInfo()
    }

    private func logoutUserInfo() {
        self.userRepository.logoutUserInfo()
    }
}
