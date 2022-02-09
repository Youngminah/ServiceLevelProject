//
//  Hobby.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import Foundation
import RxDataSources

struct Hobby {
    var content: String
}

extension Hobby: IdentifiableType, Equatable {

    var identity: String {
        return UUID().uuidString
    }
}
