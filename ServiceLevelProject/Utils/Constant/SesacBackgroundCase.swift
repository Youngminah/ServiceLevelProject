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

    var name: String {
        switch self {
        case .background0:
            return "하늘 공원"
        case .background1:
            return "씨티 뷰"
        case .background2:
            return "밤의 산책로"
        case .background3:
            return "낮의 산책로"
        case .background4:
            return "연극 무대"
        case .background5:
            return "라틴 거실"
        case .background6:
            return "홈트방"
        case .background7:
            return "뮤지션 작업실"
        }
    }

    var content: String {
        switch self {
        case .background0:
            return "새싹들을 많이 마주치는 매력적인 하늘 공원입니다"
        case .background1:
            return "창밖으로 보이는 도시 야경이 아름다운 공간입니다"
        case .background2:
            return "어둡지만 무섭지 않은 조용한 산책로입니다"
        case .background3:
            return "즐겁고 가볍게 걸을 수 있는 산책로입니다"
        case .background4:
            return "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다"
        case .background5:
            return "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다"
        case .background6:
            return "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다"
        case .background7:
            return "여러가지 음악 작업을 할 수 있는 작업실입니다"
        }
    }

    var price: String {
        switch self {
        case .background0:
            return "보유"
        case .background1:
            return "1,200"
        case .background2:
            return "1,200"
        case .background3:
            return "1,200"
        case .background4:
            return "2,500"
        case .background5:
            return "2,500"
        case .background6:
            return "2,500"
        case .background7:
            return "2,500"
        }
    }
}
