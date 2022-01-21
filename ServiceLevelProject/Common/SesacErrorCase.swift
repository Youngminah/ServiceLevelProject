//
//  SesacErrorCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import Foundation

enum SessacErrorCase: Error {

    case inValidPhoneNumberFormat
    case toManyRequest
    case with(messageId: String)

    init(errorID: String) {
        switch errorID {
        case "Invalid format.": self = .inValidPhoneNumberFormat
        case "We have blocked all requests from this device due to unusual activity. Try again later.": self = .toManyRequest
        default: self = .with(messageId: errorID)
        }
    }
}

extension SessacErrorCase {
    var errorDescription: String {
        switch self {
        case .inValidPhoneNumberFormat:
            return "잘못된 전화번호 형식입니다."
        case .toManyRequest:
            return "과도한 인증 시도가 있었습니다.\n30분뒤에 다시 시도해 주세요."
        case .with(_):
            return "에러가 발생했습니다. 다시 시도해주세요."
        }
    }
}
