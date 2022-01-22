//
//  TabBarPage.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import Foundation

enum TabBarPage: String, CaseIterable {
    case home, sesacshop, sesacfriend, mypage

    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .sesacshop
        case 2: self = .sesacfriend
        case 3: self = .mypage
        default: return nil
        }
    }

    var pageOrderNumber: Int {
        switch self {
        case .home: return 0
        case .sesacshop: return 1
        case .sesacfriend: return 2
        case .mypage: return 3
        }
    }

    var pageTitle: String {
        switch self {
        case .home:
            return "홈"
        case .sesacshop:
            return "새싹샵"
        case .sesacfriend:
            return "새싹친구"
        case .mypage:
            return "내정보"
        }
    }

    func tabIconName() -> String {
        return self.rawValue
    }
}
