//
//  SesacRepositoryType.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/24.
//

import Foundation
import Moya

protocol SesacRepositoryType: AnyObject {

    func requestUserInfo(
        completion: @escaping (Result<UserInfoResponseDTO, SesacNetworkServiceError>) -> Void
    )

    func requestRegister(
        parameters: DictionaryType,
        completion: @escaping (Result<Int, SesacNetworkServiceError>) -> Void
    )
}
