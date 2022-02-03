//
//  SesacRepositoryType.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/24.
//

import Foundation
import Moya

protocol SesacRepositoryType: AnyObject {

    func requestUserInfo(                     // 유저정보 API
        completion: @escaping (
            Result< UserInfo,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestRegister(                      // 회원가입 API
        userRegisterInfo: UserRegisterInfo,
        completion: @escaping (
            Result< Int,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestWithdraw(                       // 회원탈퇴 API
        completion: @escaping (
            Result< Int,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestUpdateUserInfo(                 // 유저정보 업데이트 API
        userUpdateInfo: UserUpdateInfo,
        completion: @escaping (
            Result<Int,
            SesacNetworkServiceError>
        ) -> Void
    )
}
