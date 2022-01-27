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
    case withdrawUser(parameters: DictionaryType)
    // User FCM
    case updateFCMToken(parameters: DictionaryType)
    // User MyPage
    case updateMyPage(parameters: DictionaryType)
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
        case .withdrawUser:
            return "/user/withdraw"
        case .updateFCMToken:
            return "/user/update_fcm_token"
        case .updateMyPage:
            return "/user/withdraw"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        case .register,
             .withdrawUser,
             .updateMyPage:
            return .post
        case .updateFCMToken:
            return .put
        }
    }

    var sampleData: Data { //더미데이터로 사용할때 꾸리기
        return stubData(self)
    }

    var task: Task {
        switch self {
        case .getUserInfo ,
             .withdrawUser:
            return .requestPlain
//        case .allComment(parameters: let parameters):
//            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .register(let parameters),
             .updateFCMToken(let parameters),
             .updateMyPage(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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