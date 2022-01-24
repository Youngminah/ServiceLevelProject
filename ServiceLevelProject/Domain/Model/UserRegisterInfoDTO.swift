//
//  UserRegisterInfo.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import Foundation

struct UserRegisterInfoDTO: Codable {

    let phoneNumber: String
    let FCMtoken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int

    var toDictionary: [String: Any] {
        let dict: [String: Any]  = [
            "phoneNumber": phoneNumber,
            "FCMtoken": FCMtoken,
            "nick": nick,
            "birth": birth,
            "email": email,
            "gender": gender,
        ]
        return dict
    }
}
