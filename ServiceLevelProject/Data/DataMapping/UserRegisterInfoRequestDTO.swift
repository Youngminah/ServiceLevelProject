//
//  UserRegisterInfo.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import Foundation

struct UserRegisterInfoRequestDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "phoneNumber": phoneNumber,
            "FCMtoken": FCMtoken,
            "nick": nick,
            "birth": birth,
            "email": email,
            "gender": gender,
        ]
        return dict
    }

    let phoneNumber: String
    let FCMtoken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int

    init(userRegisterInfo: UserRegisterInfo) {
        self.phoneNumber = transformPhoneNumber(phoneNumber: userRegisterInfo.phoneNumber)
        self.FCMtoken = userRegisterInfo.FCMtoken
        self.nick = userRegisterInfo.nick
        self.birth = userRegisterInfo.birth.dateToString()
        self.email = userRegisterInfo.email
        self.gender = userRegisterInfo.gender
    }
}

func transformPhoneNumber(phoneNumber: String) -> String {
    let index = phoneNumber.index(after: phoneNumber.startIndex)
    let formatPhoneNumber = "+82" + String(phoneNumber[index..<phoneNumber.endIndex])
    return formatPhoneNumber
}
