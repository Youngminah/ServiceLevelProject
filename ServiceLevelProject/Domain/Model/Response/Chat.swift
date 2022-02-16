//
//  Chat.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/16.
//

import Foundation

struct ChatList {

    let array: [Chat]
}

struct Chat: Equatable {

    let _id: String
    let __v: Int
    let text: String
    let createdAt: Date
    let from: String
    let to: String
}
