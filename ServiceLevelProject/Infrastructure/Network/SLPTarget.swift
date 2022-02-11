//
//  SLPTarget.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/21.
//

import Foundation
import Moya

typealias DictionaryType = [String: Any]

enum SLPTarget {
    // User
    case register(parameters: DictionaryType)
    case getUserInfo
    case withdraw
    // User FCM
    case updateFCMToken(parameters: DictionaryType)
    // User MyPage
    case updateMyPage(parameters: DictionaryType)
    // Home
    case onqueue(parameters: DictionaryType)
    case searchSesac(parameters: DictionaryType)
    case pauseSearchSesac
    case requestHobbyFriend(parameters: DictionaryType)
    case acceptHobbyFriend(parameters: DictionaryType)
    case getMyRequestStatus

}

extension SLPTarget: TargetType {

    var baseURL: URL {
        guard let url = URL(string: APIConstant.environment.rawValue) else {
            fatalError("fatal error - invalid api url")
        }
        return url
    }

    var path: String {
        switch self {
        case .register,
             .getUserInfo:
            return "/user"
        case .withdraw:
            return "/user/withdraw"
        case .updateFCMToken:
            return "/user/update_fcm_token"
        case .updateMyPage:
            return "/user/update/mypage"
        case .searchSesac,
             .pauseSearchSesac:
            return "/queue"
        case .onqueue:
            return "/queue/onqueue"
        case .requestHobbyFriend:
            return "/queue/hobbyrequest"
        case .acceptHobbyFriend:
            return "/queue/hobbyaccept"
        case .getMyRequestStatus:
            return "/queue/myQueueState"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUserInfo,
             .getMyRequestStatus:
            return .get
        case .register,
             .withdraw,
             .updateMyPage,
             .onqueue,
             .searchSesac,
             .requestHobbyFriend,
             .acceptHobbyFriend:
            return .post
        case .updateFCMToken:
            return .put
        case .pauseSearchSesac:
            return .delete
        }
    }

    var sampleData: Data { //더미데이터로 사용할때 꾸리기
        return stubData(self)
    }

    var task: Task {
        switch self {
        case .getUserInfo,
             .withdraw,
             .pauseSearchSesac,
             .getMyRequestStatus:
            return .requestPlain
        case .register(let parameters),
             .updateFCMToken(let parameters),
             .updateMyPage(let parameters),
             .onqueue(let parameters),
             .requestHobbyFriend(let parameters),
             .acceptHobbyFriend(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .searchSesac(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding(arrayEncoding: .noBrackets))
        }
    }

    var validationType: ValidationType {
        return .customCodes([200])
    }

    var headers: [String: String]? {
        let token = UserDefaults.standard.string(forKey: UserDefaultKeyCase.idToken)!
        return [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": token
        ]
    }
}
