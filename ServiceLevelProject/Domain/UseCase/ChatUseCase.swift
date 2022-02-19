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

    let successRequestMyQueueState = PublishRelay<MyQueueState>()
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
        socketIORepository: SocketIORepositoryType
    ) {
        self.userRepository = userRepository
        self.fireBaseRepository = fireBaseRepository
        self.sesacRepository = sesacRepository
        self.socketIORepository = socketIORepository
    }
}

// MARK: - 서버 레포
extension ChatUseCase {

    func requestMyQueueState() {
        self.sesacRepository.requestMyQueueState { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let myQueue):
                self.successRequestMyQueueState.accept(myQueue)
                self.saveMatchedUserIDInfo(id: myQueue.matchedUid)
                self.connectSocket()
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
        let id = self.userRepository.fetchMatchedUserIDInfo()!
        self.sesacRepository.requestSendChat(to: id, chatQuery: chatQuery)  { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let chat):
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

    //    func requestChat(to id: String, dateString: String) {
    //        self.sesacRepository.requestChat(to: id, dateString: dateString) { [weak self] response in
    //            guard let self = self else { return }
    //            switch response {
    //            case .success(let chatList):
    //                self.successChat.accept(chatList)
    //            case .failure(let error):
    //                switch error {
    //                case .inValidIDTokenError:
    //                    self.requestIDToken {
    //                        //self.requestMyQueueState()
    //                    }
    //                default:
    //                    self.unKnownErrorSignal.accept(())
    //                }
    //            }
    //        }
    //    }

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
            print("누군가에게 메세지 도착!!-->", chat)
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
