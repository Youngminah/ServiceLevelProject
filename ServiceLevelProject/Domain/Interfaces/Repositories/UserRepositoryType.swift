//
//  UserRepositoryType.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import Foundation

protocol UserRepositoryType: AnyObject {

    func fetchFCMToken() -> String?

    func deleteFCMToken()

    func fetchIDToken() -> String?

    func saveLogInInfo()

    func saveLogoutInfo()

    func saveIdTokenInfo(idToken: String)

    func deleteUserInfo()
}
