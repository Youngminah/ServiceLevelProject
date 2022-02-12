//
//  SearchSesacStatus.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/12.
//

enum SearchSesacTab: String {

    case near
    case request

    init(value: String) {
        switch value {
        case "near": self = .near
        case "request": self = .request
        default: self = .near
        }
    }

    var emptyTitle: String {
        switch self {
        case .near:
            return "아쉽게도 주변에 새싹이 없어요ㅠ"
        case .request:
            return "아직 받은 요청이 없어요ㅠ"
        }
    }

    var emptyMessage: String {
        switch self {
        case .near:
            return "취미를 변경하거나 조금만 더 기다려 주세요!"
        case .request:
            return "취미를 변경하거나 조금만 더 기다려 주세요!"
        }
    }
}
