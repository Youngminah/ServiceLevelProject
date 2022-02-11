//
//  HomeSearchItemViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/11.
//

import Foundation
import RxDataSources

struct HomeSearchItemViewModel {

    var content: String
    var isRecommended: Bool

    init(content: String, isRecommended: Bool) {
        self.content = content
        self.isRecommended = isRecommended
    }

    init(content: String) {
        self.content = content
        self.isRecommended = false
    }
}

extension HomeSearchItemViewModel: IdentifiableType, Equatable {

    var identity: String {
        return UUID().uuidString
    }
}

typealias HobbySectionModel = SectionModel<HobbySection, HobbyItem>

enum HobbySection: Int, Equatable {
    case near
    case selected

    init(index: Int) {
        switch index {
        case 0: self = .near
        default: self = .selected
        }
    }

    var headerTitle: String {
        switch self {
        case .near:
            return "지금 주변에는"
        case .selected:
            return "내가 하고 싶은"
        }
    }
}

enum HobbyItem: Equatable {
    case near(HomeSearchItemViewModel)
    case selected(HomeSearchItemViewModel)

    var hobby: HomeSearchItemViewModel {
        switch self {
        case .near(let hobby):
            return hobby
        case .selected(let hobby):
            return hobby
        }
    }
}


