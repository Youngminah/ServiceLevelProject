//
//  SesacErrorCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import Foundation

enum ToastCase: Error {

    case inValidPhoneNumberFormat
    case inValidCertificationNumberFormat
    case toManyRequest
    case timeOut
    case nickNameLimitLength
    case inValidDate
    case emptyDate
    case limitEge
    case inValidEmail
    case emptyHobbyText
    case inValidSelectedHobbyTextCount
    case limitSelectedHobbyCount
    case duplicatedSelectedHobby
    case with(messageId: String)
}

extension ToastCase {
    var errorDescription: String {
        switch self {
        case .inValidPhoneNumberFormat:
            return "잘못된 전화번호 형식입니다."
        case .inValidCertificationNumberFormat:
            return "인증번호 형식이 올바르지 않습니다."
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
        case .emptyHobbyText:
            return "취미를 입력해주세요."
        case .inValidSelectedHobbyTextCount:
            return "최소 한 자 이상, 최대 8글자까지 작성 가능합니다."
        case .limitSelectedHobbyCount:
            return "취미를 더 이상 추가할 수 없습니다."
        case .duplicatedSelectedHobby:
            return "이미 등록된 취미입니다."
        case .with(_):
            return "에러가 발생했습니다. 다시 시도해주세요."
        }
    }
}
