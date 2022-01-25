//
//  LoginUseCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import Foundation
import RxSwift

final class LoginUseCase {

    private let userRepository: UserRepositoryType
    private let fireBaseRepository: FirbaseRepositoryType

    var verifyIDSuccessSignal = PublishSubject<String>()
    var verifyIDFailSignal = PublishSubject<FirbaseNetworkServiceError>()

    init(
        userRepository: UserRepositoryType,
        fireBaseRepository: FirbaseRepositoryType
    ) {
        self.userRepository = userRepository
        self.fireBaseRepository = fireBaseRepository
    }

    func verifyPhoneNumber(phoneNumber: String) {
        self.fireBaseRepository.verifyPhoneNumber(phoneNumber: phoneNumber) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let verifyID):
                self.savePhoneNumberInfo(phoneNumber: phoneNumber)
                self.verifyIDSuccessSignal.onNext(verifyID)
            case .failure(let error):
                self.verifyIDFailSignal.onNext(error)
            }
        }
    }

    private func savePhoneNumberInfo(phoneNumber: String) {
        let index = phoneNumber.index(after: phoneNumber.startIndex)
        let formatPhoneNumber = "+82" + String(phoneNumber[index..<phoneNumber.endIndex])
        self.userRepository.savePhoneNumberInfo(phoneNumber: formatPhoneNumber)
    }
}
