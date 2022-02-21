//
//  ChatRelamRepositoryType.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/21.
//

import Foundation
import RealmSwift

protocol ChatRelamRepositoryType: AnyObject {

    func loadChat(matchedID: String) -> [Chat]            // 이전 채팅 가져오기

    func createChat(chat: Chat, matchedID: String)        // 채팅 저장하기

    func saveChatList(chats: [Chat], matchedID: String)   // 채팅 리스트 저장하기
}
