//
//  HomeUseCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/06.
//

import Foundation
import RxSwift
import RxRelay

final class HomeUseCase {

    private let userRepository: UserRepositoryType
    private let fireBaseRepository: FirbaseRepositoryType
    private let sesacRepository: SesacRepositoryType

    var successOnqueueSignal = PublishRelay<Onqueue>()
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

    func requestOnqueue(coordinate: Coordinate) {
        self.sesacRepository.requestOnqueue(userLocationInfo: coordinate) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let nearSesacDBInfo):
                self.successOnqueueSignal.accept(nearSesacDBInfo)
            case .failure(let error):
                switch error {
                case .inValidIDTokenError:
                    self.requestIDToken {
                        self.requestOnqueue(coordinate: coordinate)
                    }
                default:
                    self.unKnownErrorSignal.accept(())
                }
            }
        }
    }

    func fetchMatchStatus() -> MatchStatus {
        return self.userRepository.fetchMatchStatus()!
    }

    func fetchGender() -> GenderCase {
        return self.userRepository.fetchGender()!
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
