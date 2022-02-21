//
//  ChatDataRepository.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import Foundation
import RealmSwift

final class ChatRelamRepository: ChatRelamRepositoryType {

    var storage: RealmStorage

    init() {
        self.storage = RealmStorage.shared
    }
}

extension ChatRelamRepository {

    func loadChat(matchedID: String) -> [Chat] {
        let realmDTO = storage.read(matchedID: matchedID).toArray()
        return realmDTO.map { $0.toDomain() }
    }

    func createChat(chat: Chat, matchedID: String) {
        let chatDTO = ChatRealmDTO(chat: chat, matchedID: matchedID)
        storage.create(chat: chatDTO)
    }

    func saveChatList(chats: [Chat], matchedID: String) {
        let chatListDTO = chats.map { ChatRealmDTO(chat: $0, matchedID: matchedID) }
        storage.saveChats(chats: chatListDTO)
    }
}

extension Results {
    func toArray() -> [Element] {
      return compactMap { $0 }
    }
 }
