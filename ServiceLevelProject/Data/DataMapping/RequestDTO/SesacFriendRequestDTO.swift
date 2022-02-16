//
//  SesacFriendRequestDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/13.
//

import Foundation

struct SesacFriendRequestDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "otheruid": otheruid,
        ]
        return dict
    }

    let otheruid: String

    init(sesacFriendQuery: SesacFriendQuery) {
        otheruid = sesacFriendQuery.userID
    }
}
