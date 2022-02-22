//
//  DataBaseManager.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import Foundation
import RealmSwift

final class RealmStorage {

    static let shared = RealmStorage()
    private let realm = try! Realm()

    func read(matchedID: String) -> Results<ChatRealmDTO> {
        print("Realm is located at:", realm.configuration.fileURL!)
        return realm.objects(ChatRealmDTO.self).where { $0.matchedID == matchedID }
    }

    func create(chat: ChatRealmDTO) {
        try! realm.write {
            realm.add(chat)
        }
    }

    func saveChats(chats: [ChatRealmDTO]) {
        try! realm.write {
            realm.add(chats)
        }
    }
}
