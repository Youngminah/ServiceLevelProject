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

extension Hobby: IdentifiableType, Equatable {

    var identity: String {
        return UUID().uuidString
    }
}
