//
//  SesacErrorCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import Foundation

enum AuthError: Error {

    case inValidPhoneNumberFormat
    case toManyRequest
    case timeOut
    case nickNameLimitLength
    case inValidDate
    case emptyDate
    case limitEge
    case inValidEmail
    case with(messageId: String)
}

extension AuthError {
    var errorDescription: String {
        switch self {
        case .inValidPhoneNumberFormat:
            return "잘못된 전화번호 형식입니다."
        case .toManyRequest:
            return "과도한 인증 시도가 있었습니다.\n30분뒤에 다시 시도해 주세요."
        case .timeOut:
            return "전화번호 인증 실패"
        case .nickNameLimitLength:
            return "닉네임은 1자 이상 10자 이내로 부탁드려요."
        case .inValidDate:
            return "올바른 날짜 형식이 아닙니다."
        case .emptyDate:
            return "날짜를 입력해주세요."
        case .limitEge:
            return "만 17세 이상만 가입할 수 있습니다."
        case .inValidEmail:
            return "이메일 형식이 올바르지 않습니다."
        case .with(_):
            return "에러가 발생했습니다. 다시 시도해주세요."
        }
    }
}
