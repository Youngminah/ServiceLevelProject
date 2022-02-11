//
//  HobbySection.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import RxDataSources

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
    case near(Hobby)
    case selected(Hobby)

    var hobby: Hobby {
        switch self {
        case .near(let hobby):
            return hobby
        case .selected(let hobby):
            return hobby
        }
    }
}
