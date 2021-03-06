//
//  NearSesacInfo.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/07.
//

import Foundation

struct Onqueue {
    let fromSesacDB, fromSesacDBRequested: [SesacDB]
    let fromRecommend: [String]
}

struct SesacDB {
    let userID, nick: String
    let coordinate: Coordinate
    let reputation: [Int]
    let hobbys, reviews: [String]
    let gender: GenderCase
    let type: GenderCase
    let sesac: SesacImageCase
    let background: SesacBackgroundCase
}
