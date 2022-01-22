//
//  UserInpoResponse.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import Foundation

struct UserInfoResponse: Codable {
    let userID, phoneNumber, email, fcmToken: String
    let nick, birth: String
    let gender: Int
    let hobby: String?
    let comment: [String]
    let reputation: [Int]
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty: Int?
    let dodgepenaltyGetAt: String?
    let dodgeNum, ageMin, ageMax, searchable: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case userID = "uid"
        case phoneNumber, email
        case fcmToken = "FCMtoken"
        case nick, birth, gender, hobby, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty
        case dodgepenaltyGetAt = "dodgepenalty_getAt"
        case dodgeNum, ageMin, ageMax, searchable, createdAt
    }
}
