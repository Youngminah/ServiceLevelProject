//
//  User.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/02.
//

import Foundation

struct UserUpdateInfoRequestDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "searchable": searchable,
            "ageMin": ageMin,
            "ageMax": ageMax,
            "gender": gender,
            "hobby": hobby,
        ]
        return dict
    }

    let searchable: Int
    let ageMin: Int
    let ageMax: Int
    let gender: Int
    let hobby: String

    init(userUpdateInfo: UserUpdateQuery) {
        self.searchable = userUpdateInfo.searchable ? 1 : 0
        self.ageMin = userUpdateInfo.ageMin
        self.ageMax = userUpdateInfo.ageMax
        self.gender = userUpdateInfo.gender.value
        self.hobby = userUpdateInfo.hobby
    }
}
