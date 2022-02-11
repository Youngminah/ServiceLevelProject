//
//  UserUpdateInfo.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/02.
//

import Foundation

struct UserUpdateQuery: Equatable {

    let searchable: Bool
    let ageMin: Int
    let ageMax: Int
    let gender: GenderCase
    let hobby: String
}
