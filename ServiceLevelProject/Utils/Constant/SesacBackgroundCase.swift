//
//  SesacBackgroundCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/07.
//

import UIKit

enum SesacBackgroundCase: Int, CaseIterable {
    
    case background0 = 0

    init(value: Int) {
        switch value {
        case 0: self = .background0
        default: self = .background0
        }
    }

    var image: UIImage {
        switch self {
        case .background0:
            return Asset.defaultBackground.image
        }
    }
}
