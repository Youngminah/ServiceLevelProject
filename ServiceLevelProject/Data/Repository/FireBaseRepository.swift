//
//  FireBaseRepository.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import Foundation
import FirebaseAuth

enum FirbaseNetworkServiceError: Int, Error {

    case toManyRequest = 17010
    case unknown

    var description: String { self.errorDescription }
}

extension FirbaseNetworkServiceError {

    var errorDescription: String {
        switch self {
        case .toManyRequest: return "과도한 인증시도가 있었습니다. 1시간뒤에 다시 시도해주세요."
        default: return "에러가 발생했습니다. 다시 시도해주세요."
        }
    }
}

final class FirbaseRepository: FirbaseRepositoryType {

    let auth: Auth

    init() {
        auth = Auth.auth()
        auth.languageCode = "kr"
    }
}

extension FirbaseRepository {

    func verifyPhoneNumber(phoneNumber: String, completion: @escaping (Result<String, FirbaseNetworkServiceError>) -> Void) {
        let formatPhoneNumber = "+82" + String(phoneNumber)
        PhoneAuthProvider.provider().verifyPhoneNumber(formatPhoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                let authError = error as NSError
                print(authError.description)
                completion(.failure(FirbaseNetworkServiceError(rawValue: authError.code) ?? .unknown))
                return
            }
            completion(.success(verificationID!))
        }
    }

    func signIn(verifyID: String, certificationNumber: String, completion: @escaping (Result<Void, FirbaseNetworkServiceError>) -> Void) {
        let verificationCode = certificationNumber
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verifyID,
            verificationCode: verificationCode
        )
        auth.signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                completion(.failure(FirbaseNetworkServiceError(rawValue: authError.code) ?? .unknown))
                return
            }
            completion(.success(()))
        }
    }

    func requestIdtoken(completion: @escaping (Result<String, FirbaseNetworkServiceError>) -> Void) {
        let currentUser = auth.currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                let authError = error as NSError
                completion(.failure(FirbaseNetworkServiceError(rawValue: authError.code) ?? .unknown))
            }
            completion(.success(idToken!))
        }
    }
}
