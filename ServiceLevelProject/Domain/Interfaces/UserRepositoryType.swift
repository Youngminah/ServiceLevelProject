//
//  UserRepositoryType.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import Foundation

protocol UserRepositoryType: AnyObject {

    func fetchFCMToken() -> String?

    func fetchPhoneNumber() -> String?

    func fetchIDToken() -> String?

    func fetchNickName() -> String?

    func fetchBirth() -> Date?

    func fetchEmail() -> String?

    func fetchGender() -> Int?

    func savePhoneNumberInfo(phoneNumber: String)

    func saveGenderInfo(gender: Int) 

    func saveLogInInfo()

    func logoutUserInfo()

    func saveIdTokenInfo(idToken: String)

    func withdrawUserInfo()

    func deleteFCMToken()
}
