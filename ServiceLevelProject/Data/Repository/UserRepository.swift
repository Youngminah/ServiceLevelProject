//
//  UserRepository.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import Foundation
import RxSwift

final class UserRepository: UserRepositoryType {

    func fetchFCMToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeyCase.fcmToken)
    }

    func fetchPhoneNumber() -> String? {
        UserDefaults.standard.string(forKey: UserDefaultKeyCase.phoneNumber)
    }

    func fetchIDToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeyCase.idToken)
    }

    func fetchNickName() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeyCase.nickName)
    }

    func fetchBirth() -> Date? {
        return UserDefaults.standard.object(forKey: UserDefaultKeyCase.birth) as? Date
    }

    func fetchEmail() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeyCase.email)
    }

    func fetchGender() -> Int? {
        return UserDefaults.standard.integer(forKey: UserDefaultKeyCase.gender)
    }

    func savePhoneNumberInfo(phoneNumber: String) {
        UserDefaults.standard.set(phoneNumber, forKey: UserDefaultKeyCase.phoneNumber)
    }

    func saveIdTokenInfo(idToken: String) {
        UserDefaults.standard.set(idToken, forKey: UserDefaultKeyCase.idToken)
    }

    func saveGenderInfo(gender: Int) {
        UserDefaults.standard.set(gender, forKey: UserDefaultKeyCase.gender)
    }

    func saveLogInInfo() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeyCase.isLoggedIn)
    }

    func logoutUserInfo() {
        UserDefaults.standard.set(false, forKey: UserDefaultKeyCase.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.idToken)
    }

    func withdrawUserInfo() {
        UserDefaults.standard.setValue(false, forKey: UserDefaultKeyCase.isLoggedIn)
        UserDefaults.standard.setValue(false, forKey: UserDefaultKeyCase.isNotFirstUser)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.idToken)
    }

    func deleteFCMToken() {
        return UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.fcmToken)
    }
}
