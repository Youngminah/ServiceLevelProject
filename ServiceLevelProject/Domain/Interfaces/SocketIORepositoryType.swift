//
//  SocketIORepositoryType.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/16.
//

import Foundation
import SocketIO

protocol SocketIORepositoryType: AnyObject {

    func listenConnect(completion: @escaping ([Any], SocketAckEmitter) -> Void )

    func listenDisconnect(completion: @escaping ([Any], SocketAckEmitter) -> Void )

    func receivedChat(completion: @escaping (Chat, SocketAckEmitter) -> Void )

    func connectSocket()

    func disconnectSocket()
}
