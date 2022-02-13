//
//  SearchSesacStatus.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/12.
//

enum SearchSesacTab: String {

    case near
    case receive

    init(value: String) {
        switch value {
        case "near": self = .near
        case "receive": self = .receive
        default: self = .near
        }
    }

    var emptyTitle: String {
        switch self {
        case .near:
            return "아쉽게도 주변에 새싹이 없어요ㅠ"
        case .receive:
            return "아직 받은 요청이 없어요ㅠ"
        }
    }

    var emptyMessage: String {
        switch self {
        case .near:
            return "취미를 변경하거나 조금만 더 기다려 주세요!"
        case .receive:
            return "취미를 변경하거나 조금만 더 기다려 주세요!"
        }
    }

    var alertTitle: String {
        switch self {
        case .near:
            return "취미 같이 하기를 요청할게요!"
        case .receive:
            return "취미 같이 하기를 수락할까요?"
        }
    }

    var alertMessage: String {
        switch self {
        case .near:
            return "요청이 수락되면 30분 후에 리뷰를 남길 수 있어요"
        case .receive:
            return "요청이 수락하면 채팅창에서 대화를 나눌 수 있어요"
        }
    }

    var toastMessage: String {
        switch self {
        case .near:
            return "취미 함께 하기 요청을 보냈습니다"
        case .receive:
            return "취미 함께 하기를 수락하셧습니다."
        }
    }
}
