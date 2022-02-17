//
//  SocketIOManager.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/16.
//

import Foundation
import SocketIO

final class SocketIOManager: NSObject {

    static let shared = SocketIOManager()

    var manager: SocketManager!
    var socket: SocketIOClient!

    private let baseURL = URL(string: APIConstant.environment.rawValue + "/")!
    private let token = UserDefaults.standard.string(forKey: UserDefaultKeyCase.idToken)!

    override init() {
        super.init()
        self.manager = SocketManager(socketURL: baseURL, config: [
            .extraHeaders(["idtoken": token])
        ])
        socket = manager.defaultSocket

        let myID = UserDefaults.standard.string(forKey: UserDefaultKeyCase.myID)!

        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("SOCKET IS CONNECTED: ", data, ack)
            self?.socket.emit("changesocketid", myID)
        }
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED: ", data, ack)
        }
    }

    func listenConnect(completion: @escaping ([Any], SocketAckEmitter) -> Void ) {
        self.socket.on(clientEvent: .connect, callback: completion)
    }

    func listenDisconnect(completion: @escaping ([Any], SocketAckEmitter) -> Void ) {
        self.socket.on(clientEvent: .disconnect, callback: completion)
    }

    func receivedChatInfo(completion: @escaping ([Any], SocketAckEmitter) -> Void ) {
        self.socket.on("chat", callback: completion)
    }

    func establishConnection() {
        print("소켓연결")
        socket.connect()
    }

    func closeConnection() {
        print("소켓연결끊음")
        socket.disconnect()
    }
}
