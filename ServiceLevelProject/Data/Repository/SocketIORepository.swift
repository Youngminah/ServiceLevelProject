//
//  ChatRepository.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/16.
//

import Foundation
import SocketIO

final class SocketIORepository: SocketIORepositoryType {

    let manager = SocketIOManager.shared

    init() { }
}

extension SocketIORepository {

    func listenConnect(completion: @escaping ([Any], SocketAckEmitter) -> Void ) {
        manager.listenConnect(completion: completion)
    }

    func listenDisconnect(completion: @escaping ([Any], SocketAckEmitter) -> Void ) {
        manager.listenDisconnect(completion: completion)
    }

    func receivedChat(completion: @escaping (Chat, SocketAckEmitter) -> Void ) {
        manager.receivedChatInfo { data, ack in
            guard let dataInfo = data.first else { return }
            if let response: ChatDTO = try? self.convert(data: dataInfo) {
                completion(response.toDomain(), ack)
            }
        }
    }

    func connectSocket() {
        manager.establishConnection()
    }

    func disconnectSocket() {
        manager.closeConnection()
    }
}

extension SocketIORepository {

    private func convert<T: Decodable>(data: Any) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: jsonData)
    }
}
