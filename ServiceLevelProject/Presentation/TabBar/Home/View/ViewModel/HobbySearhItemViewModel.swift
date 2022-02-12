//
//  HobbySearhItemViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/12.
//

import Foundation

struct HobbySearchItemViewModel {

    let hobbys: [String]
    let reviews: [String]
    let reputation: [Int]
    let userID: String
    let nickname: String
    let gender: GenderCase
    let type: GenderCase
    let sesac: SesacImageCase
    let background: SesacBackgroundCase
    let coordinate: Coordinate

    init(sesacDB: SesacDB){
        hobbys = sesacDB.hobbys
        reviews = sesacDB.reviews
        reputation = sesacDB.reputation
        userID = sesacDB.userID
        nickname = sesacDB.nick
        gender = sesacDB.gender
        type = sesacDB.type
        sesac = sesacDB.sesac
        background = sesacDB.background
        coordinate = sesacDB.coordinate
    }
}
