//
//  UserRegisterInfo.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/26.
//

import Foundation

struct UserRegisterInfo: Equatable {

    let phoneNumber: String
    let FCMtoken: String
    let nick: String
    let birth: Date
    let email: String
    let gender: Int
}
