//
//  SLPTarget+StupData.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import Foundation

extension SLPTarget {
    func stubData(_ target: SLPTarget) -> Data {
        switch self {
        case .getUserInfo:
            return Data(
                """
                {
                    "_id": "61d9b05be83f1515ee3ce64e",
                    "__v": 0,
                    "uid": "NuK12cdVaDVcc9e4ctxsLMNCrHQ2",
                    "phoneNumber": "+821012345678",
                    "email": "test@gmail.com",
                    "FCMtoken": "dzjnejNDh0d0u1aLzfS547:APA91bFvQSjDVFC4-2IA0QQ08KqsEKwIoK2hFBZIfdyNLPd22PvgLD6YM_kyQgv0BIK-1zjltbbKYQTGK50Pn21bctsuEC46qo7RDkcImbzyZBe0-ffMqhFhL4DO5tbP0Ri_Wn-vRVF5",
                    "nick": "고래밥",
                    "birth": "2021-01-30T08:30:20.000Z",
                    "gender": 0,
                    "hobby": "Coding",
                    "comment": ["착합니다", "매너가 최고에요!!"],
                    "reputation": [1,0,1,0,1,0,1,0,1],
                    "sesac": 0,
                    "sesacCollection": [0,1],
                    "background": 0,
                    "backgroundCollection": [0,1],
                    "purchaseToken": ["purchaseToken", "purchaseToken"],
                    "transactionId": ["transactionId", "transactionId"],
                    "reviewedBefore": ["NuK12cdVaDVcc9e4ctxsLMNCrHQ2","x4r4tjQZ8Pf9mFYUgkfmC4REcvu2"],
                    "reportedNum": 0,
                    "reportedUser": ["NuK12cdVaDVcc9e4ctxsLMNCrHQ2","x4r4tjQZ8Pf9mFYUgkfmC4REcvu2"],
                    "dodgepenalty": 0,
                    "dodgepenalty_getAt": "2021-01-30T08:30:20.000Z",
                    "dodgeNum": 0,
                    "ageMin": 20,
                    "ageMax": 30,
                    "searchable": 1,
                    "createdAt": "2021-01-30T08:30:20.000Z"
                }
                """.utf8
            )
        default:
            return Data(
                """
                """.utf8
            )
        }
    }
}
