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
        userRegisterInfo: UserRegisterQuery,
        completion: @escaping (
            Result< UserInfo,
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
        userUpdateInfo: UserUpdateQuery,
        completion: @escaping (
            Result< Int,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestOnqueue(                        // 주변 새싹 위치 정보 API
        userLocationInfo: Coordinate,
        completion: @escaping (
            Result< Onqueue,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestSearchSesac(                     // 새싹 찾기 요청 API
        searchSesacQuery: SearchSesacQuery,
        completion: @escaping (
            Result< Int,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestPauseSearchSesac(                // 새싹 찾기 중단 API
        completion: @escaping (
            Result< Int,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestSesacFriend(                     // 새싹 친구 요청 API
        sesacFriendQuery: SesacFriendQuery,
        completion: @escaping (
            Result< Int,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestAcceptSesacFriend(               // 새싹 친구 수락 API
        sesacFriendQuery: SesacFriendQuery,
        completion: @escaping (
            Result< Int,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestMyQueueState(                    // 본인 매칭상태 확인 API
        completion: @escaping (
            Result< MyQueueState,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestSendChat(                        // 채팅 전송 API
        to id: String,
        chatQuery: ChatQuery,
        completion: @escaping (
            Result< Chat,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestChat(                            // 채팅 가져오기 API
        to id: String,
        dateString: String,
        completion: @escaping (
            Result< ChatList,
            SesacNetworkServiceError>
        ) -> Void
    )

    func requestDodge(                           // 대화방 나가기 API
        dodgeQuery: DodgeQuery,
        completion: @escaping (
            Result< Int,
            SesacNetworkServiceError>
        ) -> Void
    )

    func reqeustWriteReview(                     // 리뷰 쓰기 ARI
        to id: String,
        review: ReviewQuery,
        completion: @escaping (
            Result< Int,
            SesacNetworkServiceError>
        ) -> Void
    )
}
