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
    var failRegisterSignal = PublishSubject<SesacNetworkServiceError>()

    init(
        userRepository: UserRepositoryType,
        sesacRepository: SesacRepositoryType
    ) {
        self.userRepository = userRepository
        self.sesacRepository = sesacRepository
    }

    func requestRegister(gender: Int) {
        saveGenderInfo(gender: gender)
        
        let parameters = makeUserInfoBodyParameters()
        sesacRepository.requestRegister(parameters: parameters) { response in
            switch response {
            case .success(_):
                self.successRegisterSignal.onNext(())
            case .failure(let error):
                self.failRegisterSignal.onNext(error)
            }
        }
    }

    private func makeUserInfoBodyParameters() -> DictionaryType {
        let fcmToken = self.fetchFCMToken()
        let (nickName, birth, email, gender) = fetchUserInfo()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        let dateString = dateFormatter.string(from: birth)
        let userInfo = UserRegisterInfoDTO(
            phoneNumber: fetchFCMToken(),
            FCMtoken: fcmToken,
            nick: nickName,
            birth: dateString,
            email: email,
            gender: gender
        )
        return userInfo.toDictionary
    }

    private func fetchFCMToken() -> String {
        return self.userRepository.fetchFCMToken()!
    }

    private func saveGenderInfo(gender: Int) {
        self.userRepository.saveGenderInfo(gender: gender)
    }

    private func saveLogInInfo() {
        self.userRepository.saveLogInInfo()
    }

    private func fetchUserInfo() -> (String, Date, String, Int) {
        return (
            self.userRepository.fetchNickName()!,
            self.userRepository.fetchBirth()!,
            self.userRepository.fetchEmail()!,
            self.userRepository.fetchGender()!
        )
    }
}
