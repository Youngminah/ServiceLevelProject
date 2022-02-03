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
    var successUpdateSignal = PublishRelay<Void>()
    var failLogoutSignal = PublishRelay<Void>()

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
                    self.failLogoutSignal.accept(())
                case .inValidIDTokenError:
                    self.requestIDToken()
                default:
                    self.logoutUserInfo()
                    self.failLogoutSignal.accept(())
                }
            }
        }
    }

    func requestUpdateUserInfo(updateUserInfo: UpdateUserInfo) {
        let info = UserUpdateInfo(searchable: updateUserInfo.0, ageMin: updateUserInfo.1, ageMax: updateUserInfo.2, gender: updateUserInfo.3, hobby: updateUserInfo.4!)
        sesacRepository.requestUpdateUserInfo(userUpdateInfo: info) { response in
            switch response {
            case .success(_):
                self.successUpdateSignal.accept(())
            case .failure(let error):
                print(error.description)
                switch error {
                case .inValidIDTokenError:
                    self.requestIDToken()
                default:
                    self.logoutUserInfo()
                    self.failLogoutSignal.accept(())
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
                self.failLogoutSignal.accept(())
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
