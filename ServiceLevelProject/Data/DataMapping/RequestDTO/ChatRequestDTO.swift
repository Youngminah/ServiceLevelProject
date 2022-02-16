//
//  ChatRequestDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/16.
//

import Foundation

struct ChatRequestDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "chat": chat,
        ]
        return dict
    }

    let chat: String

    init(chatQuery: ChatQuery) {
        chat = chatQuery.text
    }
}
