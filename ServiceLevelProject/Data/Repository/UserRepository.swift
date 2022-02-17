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

    func fetchGender() -> GenderCase? {
        let value = UserDefaults.standard.integer(forKey: UserDefaultKeyCase.gender)
        return GenderCase(value: value)
    }

    func fetchMatchStatus() -> MatchStatus? {
        let value = UserDefaults.standard.string(forKey: UserDefaultKeyCase.matchStatus) ?? ""
        return MatchStatus(value: value)
    }

    func fetchMatchedUserIDInfo() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeyCase.matchesUserID)
    }

    func fetchMyIDInfo() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeyCase.myID)
    }

    func saveMyIDInfo(id: String) {
        UserDefaults.standard.set(id, forKey: UserDefaultKeyCase.myID)
    }

    func saveMatchedUserIDInfo(id: String) {
        UserDefaults.standard.set(id, forKey: UserDefaultKeyCase.matchesUserID)
    }

    func savePhoneNumberInfo(phoneNumber: String) {
        UserDefaults.standard.set(phoneNumber, forKey: UserDefaultKeyCase.phoneNumber)
    }

    func saveIdTokenInfo(idToken: String) {
        UserDefaults.standard.set(idToken, forKey: UserDefaultKeyCase.idToken)
    }

    func saveGenderInfo(gender: GenderCase) {
        let genderValue = gender.value
        UserDefaults.standard.set(genderValue, forKey: UserDefaultKeyCase.gender)
    }

    func saveLogInInfo() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeyCase.isLoggedIn)
    }

    func saveBirthInfo(birth: Date) {
        UserDefaults.standard.set(birth, forKey: UserDefaultKeyCase.birth)
    }

    func saveEmailInfo(email: String) {
        UserDefaults.standard.set(email, forKey: UserDefaultKeyCase.email)
    }

    func saveNicknameInfo(nickname: String) {
        UserDefaults.standard.set(nickname, forKey: UserDefaultKeyCase.nickName)
    }

    func saveMatchStatus(status: MatchStatus) {
        UserDefaults.standard.set(status.rawValue, forKey: UserDefaultKeyCase.matchStatus)
    }

    func logoutUserInfo() {
        UserDefaults.standard.set(false, forKey: UserDefaultKeyCase.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.idToken)
    }

    func withdrawUserInfo() {
        UserDefaults.standard.setValue(false, forKey: UserDefaultKeyCase.isLoggedIn)
        UserDefaults.standard.setValue(false, forKey: UserDefaultKeyCase.isNotFirstUser)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.matchStatus)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.gender)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.phoneNumber)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.email)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.birth)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.idToken)
    }

    func deleteFCMToken() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.fcmToken)
    }

    func deleteMatchedUserIDInfo() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeyCase.matchesUserID)
    }
}
