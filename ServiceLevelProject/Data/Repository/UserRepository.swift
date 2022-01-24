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

    func deleteFCMToken() {
        return UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.fcmToken)
    }

    func fetchIDToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeyCase.idToken)
    }

    func saveIdTokenInfo(idToken: String) {
        UserDefaults.standard.set(idToken, forKey: UserDefaultKeyCase.idToken)
    }

    func saveLogInInfo() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeyCase.isLoggedIn)
    }

    func saveLogoutInfo() {
        UserDefaults.standard.set(false, forKey: UserDefaultKeyCase.isLoggedIn)
    }

    func deleteUserInfo() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.idToken)
    }
}
