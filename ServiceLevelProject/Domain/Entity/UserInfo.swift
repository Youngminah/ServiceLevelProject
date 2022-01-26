//
//  UserInfo.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/26.
//

import Foundation

struct UserInfo: Equatable {

    let userID, phoneNumber, email, fcmToken, nick, birth: String
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
    let dodgeNum, ageMin, ageMax, searchable: Int
    let createdAt: String
}
