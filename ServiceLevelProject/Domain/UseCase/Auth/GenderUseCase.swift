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

    func requestRegister(gender: GenderCase) {
        saveGenderInfo(gender: gender)
        let userRegisterInfo = makeUserRegisterInfo()
        sesacRepository.requestRegister(userRegisterInfo: userRegisterInfo) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let userInfo):
                self.saveLogInInfo(user: userInfo)
                self.successRegisterSignal.onNext(())
            case .failure(let error):
                self.failRegisterSignal.onNext(error)
            }
        }
    }

    private func makeUserRegisterInfo() -> UserRegisterQuery {
        let fcmToken = fetchFCMToken()
        let (nickName, birth, email, gender) = fetchUserInfo()
        let userRegisterInfo = UserRegisterQuery(
            phoneNumber: fetchPhoneNumber(),
            FCMtoken: fcmToken,
            nick: nickName,
            birth: birth,
            email: email,
            gender: gender
        )
        return userRegisterInfo
    }

    private func fetchFCMToken() -> String {
        return self.userRepository.fetchFCMToken()!
    }

    private func fetchPhoneNumber() -> String {
        return self.userRepository.fetchPhoneNumber()!
    }

    private func saveGenderInfo(gender: GenderCase) {
        self.userRepository.saveGenderInfo(gender: gender)
    }

    private func saveLogInInfo(user info: UserInfo) {
        self.userRepository.saveLogInInfo()
        self.userRepository.saveNicknameInfo(nickname: info.nick)
        self.userRepository.saveBirthInfo(birth: info.birth.toDate)
        self.userRepository.saveEmailInfo(email: info.email)
        self.userRepository.saveMyIDInfo(id: info.userID)
        self.userRepository.saveGenderInfo(gender: info.gender)
        self.userRepository.savePhoneNumberInfo(phoneNumber: info.phoneNumber)
    }

    private func fetchUserInfo() -> (String, Date, String, GenderCase) {
        return (
            self.userRepository.fetchNickName()!,
            self.userRepository.fetchBirth()!,
            self.userRepository.fetchEmail()!,
            self.userRepository.fetchGender()!
        )
    }
}
