//
//  RegisterUseCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import Foundation
import RxSwift

final class GenderUseCase {

    private let userRepository: UserRepositoryType
    private let sesacRepository: SesacRepositoryType

    var successRegisterSignal = PublishSubject<Void>()
    var failRegisterSignal = PublishSubject<Int>()

    init(
        userRepository: UserRepositoryType,
        sesacRepository: SesacRepositoryType
    ) {
        self.userRepository = userRepository
        self.sesacRepository = sesacRepository
    }

    func requestRegister() {
        let parameters = makeUserInfoBodyParameters()
        self.sesacRepository.requestRegister(parameters: parameters) { response in
            switch response {
            case .success(_):
                self.successRegisterSignal.onNext(())
            case .failure(let error):
                self.failRegisterSignal.onNext(error.rawValue)
            }
        }
    }

    private func makeUserInfoBodyParameters() -> DictionaryType {
        let fcmToken = self.fetchFCMToken()!
        let userInfo = UserRegisterInfoDTO(
            phoneNumber: "+821088407593",
            FCMtoken: fcmToken,
            nick: "youngmin",
            birth: "1994-11-14T09:23:44.054Z",
            email: "youngminah@gmail.com",
            gender: 1
        )
        return userInfo.toDictionary
    }

    private func fetchFCMToken() -> String? {
        return self.userRepository.fetchFCMToken()
    }

    private func saveLogInInfo() {
        self.userRepository.saveLogInInfo()
    }
}
