//
//  ChatUseCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/15.
//

import Foundation
import RxSwift
import RxRelay
import SocketIO

final class ChatUseCase {

    private let userRepository: UserRepositoryType
    private let fireBaseRepository: FirbaseRepositoryType
    private let sesacRepository: SesacRepositoryType
    private let socketIORepository: SocketIORepositoryType
    private let chatRealmRepository: ChatRelamRepositoryType

    let successRequestMyQueueState = PublishRelay<MyQueueState>()
    let successLoadRealmChat = PublishRelay<[Chat]>()
    let successRequestChatList = PublishRelay<[Chat]>()
    let receivedChat = PublishRelay<Chat>()
    let sendChat = PublishRelay<Chat>()
    let sendChatErrorSignal = PublishRelay<SesacNetworkServiceError>()
    let successRequestDodge = PublishRelay<Void>()
    let successReview = PublishRelay<Void>()
    let successReport = PublishRelay<Void>()
    let unKnownErrorSignal = PublishRelay<Void>()

    init(
        userRepository: UserRepositoryType,
        fireBaseRepository: FirbaseRepositoryType,
        sesacRepository: SesacRepositoryType,
        socketIORepository: SocketIORepositoryType,
        chatRealmRepository: ChatRelamRepositoryType
    ) {
        self.userRepository = userRepository
        self.fireBaseRepository = fireBaseRepository
        self.sesacRepository = sesacRepository
        self.socketIORepository = socketIORepository
        self.chatRealmRepository = chatRealmRepository
    }
}

// MARK: - 서버 레포
extension ChatUseCase {

    func requestMyQueueState() {
        self.sesacRepository.requestMyQueueState { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let myQueue):
                self.saveMatchedUserIDInfo(id: myQueue.matchedUid)
                self.successRequestMyQueueState.accept(myQueue)
            case .failure(let error):
                switch error {
                case .inValidIDTokenError:
                    self.requestIDToken {
                        self.requestMyQueueState()
                    }
                default:
                    self.unKnownErrorSignal.accept(())
                }
            }
        }
    }

    func requestSendChat(chatQuery: ChatQuery) {
        let id = self.fetchMatchedUserIDInfo()
        self.sesacRepository.requestSendChat(to: id, chatQuery: chatQuery)  { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let chat):
                self.createChat(chat: chat)
                self.sendChat.accept(chat)
            case .failure(let error):
                switch error {
                case .inValidIDTokenError:
                    self.requestIDToken {
                        self.requestSendChat(chatQuery: chatQuery)
                    }
                default:
                    self.sendChatErrorSignal.accept(error)
                }
            }
        }
    }

    func requestDodge() {
        let matchedUserID = fetchMatchedUserIDInfo()
        let dodgeInfo = DodgeQuery(matchedUserID: matchedUserID)
        self.sesacRepository.requestDodge(dodgeQuery: dodgeInfo) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(_):
                self.saveMatchStatus(status: .general)
                self.deleteMatchedUserIDInfo()
                self.successRequestDodge.accept(())
            case .failure(let error):
                switch error {
                case .inValidIDTokenError:
                    self.requestIDToken {
                        self.requestDodge()
                    }
                default:
                    self.unKnownErrorSignal.accept(())
                }
            }
        }
    }

    func reqeustWriteReview(reputation: [Int], review text: String) {
        let matchedUserID = fetchMatchedUserIDInfo()
        let reviewInfo = ReviewQuery(matchedUserID: matchedUserID, reputation: reputation, text: text)
        self.sesacRepository.reqeustWriteReview(to: matchedUserID, review: reviewInfo)  { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(_):
                self.saveMatchStatus(status: .general)
                self.deleteMatchedUserIDInfo()
                self.successReview.accept(())
            case .failure(let error):
                switch error {
                case .inValidIDTokenError:
                    self.requestIDToken {
                        self.reqeustWriteReview(reputation: reputation, review: text)
                    }
                default:
                    self.unKnownErrorSignal.accept(())
                }
            }
        }
    }

    func requestReport(report: [Int], comment text: String) {
        let matchedUserID = fetchMatchedUserIDInfo()
        let reportInfo = ReportQuery(matchedUserID: matchedUserID, report: report, text: text)
        self.sesacRepository.requestReport(report: reportInfo)  { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(_):
                self.successReport.accept(())
            case .failure(let error):
                switch error {
                case .inValidIDTokenError:
                    self.requestIDToken {
                        self.requestReport(report: report, comment: text)
                    }
                default:
                    self.unKnownErrorSignal.accept(())
                }
            }
        }
    }

    func requestChat(dateString: String) {
        let matchedUserID = fetchMatchedUserIDInfo()
        self.sesacRepository.requestChat(to: matchedUserID, dateString: dateString) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let chatList):
                self.saveChatList(chats: chatList.array)
                self.successRequestChatList.accept(chatList.array)
            case .failure(let error):
                switch error {
                case .inValidIDTokenError:
                    self.requestIDToken {
                        self.requestChat(dateString: dateString)
                    }
                default:
                    self.unKnownErrorSignal.accept(())
                }
            }
        }
    }

    private func requestIDToken(completion: @escaping () -> Void) {
        fireBaseRepository.requestIdtoken { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let idToken):
                print("재발급 성공--> \(idToken)")
                self.saveIdTokenInfo(idToken: idToken)
                completion()
            case .failure(let error):
                print(error.description)
                self.logoutUserInfo()
                self.unKnownErrorSignal.accept(())
            }
        }
    }
}

// MARK: - 소켓 통신 레포
extension ChatUseCase {

    func socketChatInfo() {
        self.socketIORepository.receivedChat { [weak self] chat, ack in
            self?.createChat(chat: chat)
            self?.receivedChat.accept(chat)
        }
    }

    func connectSocket() {
        self.socketIORepository.connectSocket()
    }

    func disconnectSocket() {
        self.socketIORepository.disconnectSocket()
    }

    func listenConnect() {
        self.socketIORepository.listenConnect { data, ack in
            print("SOCKET IS CONNECTED: ", data, ack)
        }
    }

    func listenDisconnect() {
        self.socketIORepository.listenDisconnect { data, ack in
            print("SOCKET IS DISCONNECTED: ", data, ack)
        }
    }
}

// MARK: - 램 데이터베이스 레포 연결
extension ChatUseCase {

    func createChat(chat: Chat) {
        let matchedID = fetchMatchedUserIDInfo()
        self.chatRealmRepository.createChat(chat: chat, matchedID: matchedID)
    }

    func loadChat() {
        let matchedID = fetchMatchedUserIDInfo()
        let chatList = self.chatRealmRepository.loadChat(matchedID: matchedID)
        self.successLoadRealmChat.accept(chatList)
    }

    func saveChatList(chats: [Chat]) {
        let matchedID = fetchMatchedUserIDInfo()
        self.chatRealmRepository.saveChatList(chats: chats, matchedID: matchedID)
    }
}

// MARK: - 유저 디폴트 레포 연결
extension ChatUseCase {

    private func fetchMatchedUserIDInfo() -> String {
        self.userRepository.fetchMatchedUserIDInfo()!
    }

    private func saveMatchStatus(status: MatchStatus) {
        self.userRepository.saveMatchStatus(status: status)
    }

    private func saveMatchedUserIDInfo(id: String) {
        self.userRepository.saveMatchedUserIDInfo(id: id)
    }

    private func saveIdTokenInfo(idToken: String) {
        self.userRepository.saveIdTokenInfo(idToken: idToken)
    }

    private func logoutUserInfo() {
        self.userRepository.logoutUserInfo()
    }

    private func deleteMatchedUserIDInfo() {
        self.userRepository.deleteMatchedUserIDInfo()
    }
}
