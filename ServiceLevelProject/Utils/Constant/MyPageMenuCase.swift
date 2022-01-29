//
//  MyPageMenuCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import Foundation

enum MyPageMenuCase: String, CaseIterable {

    case notice, question, inquiry, notification, terms

    init?(index: Int) {
        switch index {
        case 0: self = .notice
        case 1: self = .question
        case 2: self = .inquiry
        case 3: self = .notification
        case 4: self = .terms
        default: return nil
        }
    }

    var index: Int {
        switch self {
        case .notice:
            return 0
        case .question:
            return 1
        case .inquiry:
            return 2
        case .notification:
            return 3
        case .terms:
            return 4
        }
    }

    var title: String {
        switch self {
        case .notice:
            return "공지사항"
        case .question:
            return "자주 묻는 질문"
        case .inquiry:
            return "1:1 문의"
        case .notification:
            return "알림 설정"
        case .terms:
            return "이용 약관"
        }
    }

    var imageName: String {
        return self.rawValue
    }
}
