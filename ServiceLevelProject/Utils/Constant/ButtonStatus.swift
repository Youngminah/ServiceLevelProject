//
//  ButtonStatus.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import UIKit

enum ButtonStatus: String {

    case inactive
    case fill
    case outline
    case cancel
    case disable

    var backgroundColor: UIColor {
        switch self {
        case .inactive:
            return .white
        case .fill:
            return .green
        case .outline:
            return .white
        case .cancel:
            return .gray2
        case .disable:
            return .gray6
        }
    }

    var titleColor: UIColor {
        switch self {
        case .inactive, .cancel:
            return .black
        case .fill, .disable:
            return .white
        case .outline:
            return .green
        }
    }

    var borderColor: CGColor {
        switch self {
        case .inactive:
            return UIColor.gray4.cgColor
        case .fill:
            return UIColor.green.cgColor
        case .outline:
            return UIColor.green.cgColor
        case .cancel:
            return UIColor.gray1.cgColor
        case .disable:
            return UIColor.gray6.cgColor
        }
    }
}
