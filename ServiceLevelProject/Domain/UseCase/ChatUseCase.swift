//
//  ChatUseCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/15.
//

import Foundation
import RxSwift
import RxRelay

final class ChatUseCase {

    private let userRepository: UserRepositoryType
    private let fireBaseRepository: FirbaseRepositoryType
    private let sesacRepository: SesacRepositoryType

    private let successRequestMyQueueState = PublishRelay<MyQueueState>()
    var unKnownErrorSignal = PublishRelay<Void>()

    init(
        userRepository: UserRepositoryType,
        fireBaseRepository: FirbaseRepositoryType,
        sesacRepository: SesacRepositoryType
    ) {
        self.userRepository = userRepository
        self.fireBaseRepository = fireBaseRepository
        self.sesacRepository = sesacRepository
    }

    func requestMyQueueState() {
        self.sesacRepository.requestMyQueueState { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let myQueue):
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

    private func saveIdTokenInfo(idToken: String) {
        self.userRepository.saveIdTokenInfo(idToken: idToken)
    }

    private func logoutUserInfo() {
        self.userRepository.logoutUserInfo()
    }
}
