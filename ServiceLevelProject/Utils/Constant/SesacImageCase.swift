//
//  SesacImageCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/07.
//

import UIKit

enum SesacImageCase: Int, CaseIterable {
    case sesac0 = 0
    case sesac1 = 1
    case sesac2 = 2
    case sesac3 = 3
    case sesac4 = 4

    init(value: Int) {
        switch value {
        case 0: self = .sesac0
        case 1: self = .sesac1
        case 2: self = .sesac2
        case 3: self = .sesac3
        case 4: self = .sesac4
        default: self = .sesac0
        }
    }

    var image: UIImage {
        switch self {
        case .sesac0:
            return Asset.sesac1.image
        case .sesac1:
            return Asset.sesac2.image
        case .sesac2:
            return Asset.sesac3.image
        case .sesac3:
            return Asset.sesac4.image
        case .sesac4:
            return Asset.sesac5.image
        }
    }
}
