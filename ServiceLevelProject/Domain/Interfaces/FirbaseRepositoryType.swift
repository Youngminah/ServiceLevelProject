//
//  FirbaseRepositoryType.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/24.
//

import Foundation

protocol FirbaseRepositoryType: AnyObject {

    func verifyPhoneNumber(
        phoneNumber: String,
        completion: @escaping (
            Result <String,
            FirbaseNetworkServiceError>
        ) -> Void
    )

    func signIn(
        verifyID: String,
        certificationNumber: String,
        completion: @escaping (
            Result <Void,
            FirbaseNetworkServiceError>
        ) -> Void
    )

    func requestIdtoken(
        completion: @escaping (
            Result <String,
            FirbaseNetworkServiceError>
        ) -> Void
    )
}
