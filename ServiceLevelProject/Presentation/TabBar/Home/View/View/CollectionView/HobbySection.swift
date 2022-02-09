//
//  HobbySection.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import RxDataSources

//typealias HobbySection = SectionModel<String, Hobby>

typealias HobbySectionModel = SectionModel<HobbySection, HobbyItem>

enum HobbySection: Equatable {
    case near
    case selected
}

enum HobbyItem: Equatable {
    case near(Hobby)
    case selected(Hobby)
}
