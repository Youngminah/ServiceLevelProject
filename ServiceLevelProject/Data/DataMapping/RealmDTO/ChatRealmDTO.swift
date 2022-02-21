//
//  ChatDataDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import Foundation
import RealmSwift

final class ChatRealmDTO: Object {

    @Persisted var __v: Int
    @Persisted var text: String
    @Persisted var createdAt: Date
    @Persisted var from: String
    @Persisted var to: String
    @Persisted var matchedID: String
    @Persisted(primaryKey: true) var _id: String

    convenience init(chat: Chat, matchedID: String) {
        self.init()
        self._id = chat._id
        self.__v = chat.__v
        self.text = chat.text
        self.createdAt = chat.createdAt
        self.from = chat.from
        self.to = chat.to
        self.matchedID = matchedID
    }
}

extension ChatRealmDTO {

    func toDomain() -> Chat {
        return .init(
            _id: _id,
            __v: __v,
            text: text,
            createdAt: createdAt,
            from: from,
            to: to
        )
    }
}
