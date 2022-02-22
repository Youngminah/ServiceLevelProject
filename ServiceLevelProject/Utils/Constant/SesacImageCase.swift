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

    var name: String {
        switch self {
        case .sesac0:
            return "기본 새싹"
        case .sesac1:
            return "튼튼 새싹"
        case .sesac2:
            return "민트 새싹"
        case .sesac3:
            return "퍼플 새싹"
        case .sesac4:
            return "골드 새싹"
        }
    }

    var content: String {
        switch self {
        case .sesac0:
            return "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
        case .sesac1:
            return "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다."
        case .sesac2:
            return "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다."
        case .sesac3:
            return "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다."
        case .sesac4:
            return "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."
        }
    }

    var price: String {
        switch self {
        case .sesac0:
            return "기본"
        case .sesac1:
            return "1,200"
        case .sesac2:
            return "2,500"
        case .sesac3:
            return "2,500"
        case .sesac4:
            return "2,500"
        }
    }

    var identifier: String {
        switch self {
        case .sesac0:
            return "기본"
        case .sesac1:
            return "com.memolease.sesac1.sprout1"
        case .sesac2:
            return "com.memolease.sesac1.sprout2"
        case .sesac3:
            return "com.memolease.sesac1.sprout3"
        case .sesac4:
            return "com.memolease.sesac1.sprout4"
        }
    }
}
