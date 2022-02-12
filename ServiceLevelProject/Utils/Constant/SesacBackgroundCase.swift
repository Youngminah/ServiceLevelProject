//
//  SesacBackgroundCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/07.
//

import UIKit

enum SesacBackgroundCase: Int, CaseIterable {
    
    case background0 = 0
    case background1
    case background2
    case background3
    case background4
    case background5
    case background6
    case background7

    init(value: Int) {
        switch value {
        case 0: self = .background0
        case 1: self = .background1
        case 2: self = .background2
        case 3: self = .background3
        case 4: self = .background4
        case 5: self = .background5
        case 6: self = .background6
        case 7: self = .background7
        default: self = .background0
        }
    }

    var image: UIImage {
        switch self {
        case .background0:
            return Asset.defaultBackground.image
        case .background1:
            return Asset.background2.image
        case .background2:
            return Asset.background3.image
        case .background3:
            return Asset.background4.image
        case .background4:
            return Asset.background5.image
        case .background5:
            return Asset.background6.image
        case .background6:
            return Asset.background7.image
        case .background7:
            return Asset.background8.image
        }
    }
}
