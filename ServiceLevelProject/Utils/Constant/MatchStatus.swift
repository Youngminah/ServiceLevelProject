//
//  MatchStatus.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/11.
//

import Foundation
import UIKit

enum MatchStatus: String {

    case general
    case matching
    case matched

    init(value: String) {
        switch value {
        case "general": self = .general
        case "matching": self = .matching
        case "matched": self = .matched
        default: self = .general
        }
    }

    var image: UIImage {
        switch self {
        case .general:
            return Asset.search.image
        case .matching:
            return Asset.antenna.image
        case .matched:
            return Asset.message.image
        }
    }
}
