//
//  DodgeRequestDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/17.
//

import Foundation

struct DodgeRequestDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "otheruid": otheruid,
        ]
        return dict
    }

    let otheruid: String

    init(dodgeQuery: DodgeQuery) {
        otheruid = dodgeQuery.matchedUserID
    }
}
