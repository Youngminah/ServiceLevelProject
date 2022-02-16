//
//  MyQueueStateDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/15.
//

import Foundation

struct MyQueueStateResponseDTO: Codable {

    private enum CodingKeys: String, CodingKey {
        case dodged
        case matched
        case reviewed
        case matchedNickname = "matchedNick"
        case matchedUserID = "matchedUid"

    }

    let dodged: Int
    let matched: Int
    let reviewed: Int
    let matchedNickname: String
    let matchedUserID: String
}

extension MyQueueStateResponseDTO {

    func toDomain() -> MyQueueState {
        return .init(
            dodged: dodged,
            matched: matched,
            reviewed: reviewed,
            matchedNick: matchedNickname,
            matchedUid: matchedUserID
        )
    }
}
