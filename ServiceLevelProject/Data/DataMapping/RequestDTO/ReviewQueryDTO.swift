//
//  ReviewQueryDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/17.
//

import Foundation

struct ReviewRequestDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "otheruid": otheruid,
            "reputation": reputation,
            "comment": comment
        ]
        return dict
    }

    let otheruid: String
    let reputation: [Int]
    let comment: String

    init(review: ReviewQuery) {
        otheruid = review.matchedUserID
        reputation = review.reputation
        comment = review.text
    }
}
