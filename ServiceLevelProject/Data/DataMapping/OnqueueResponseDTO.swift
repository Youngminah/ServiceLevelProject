//
//  OnqueueResponseDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/07.
//

import Foundation

struct OnqueueResponseDTO: Codable {
    
    let fromQueueDB, fromQueueDBRequested: [QueueDB]
    let fromRecommend: [String]
}

struct QueueDB: Codable {

    private enum CodingKeys: String, CodingKey {
        case userID = "uid"
        case nick
        case latitude = "lat"
        case longitude = "long"
        case reputation, reviews
        case hobbys = "hf"
        case gender, type, sesac, background
    }

    let userID, nick: String
    let latitude, longitude: Double
    let reputation: [Int]
    let hobbys, reviews: [String]
    let gender, type, sesac, background: Int
}


extension OnqueueResponseDTO {

    func toDomain() -> NearSesacDBInfo {
        return .init(
            fromSesacDB: fromQueueDB.map { $0.toDomain() },
            fromSesacDBRequested: fromQueueDBRequested.map { $0.toDomain() },
            fromRecommend: fromRecommend
        )
    }
}

extension QueueDB {

    func toDomain() -> SesacDB {
        return .init(
            userID: userID,
            nick: nick,
            coordinator: Coordinate(latitude: latitude, longitude: longitude),
            reputation: reputation,
            hobbys: hobbys,
            reviews: reviews,
            gender: gender,
            type: type,
            sesac: sesac,
            background: background
        )
    }
}
