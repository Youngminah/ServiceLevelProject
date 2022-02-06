//
//  MapStatusButton.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/04.
//

import UIKit.UIButton

enum MapStatus {
    case search
    case matching
    case matched

    var image: UIImage {
        switch self {
        case .search:
            return Asset.search.image
        case .matching:
            return Asset.antenna.image
        case .matched:
            return Asset.message.image
        }
    }
}

final class MapStatusButton: UIButton {

    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
        super.init(frame: frame)
    }

    convenience init(status: MapStatus) {
        self.init()
        setConfiguration()
        setValidStatus(status: status)
    }

    required init?(coder: NSCoder) {
        fatalError("MapStatusButton: fatal Error Message")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = bounds.width / 2
    }

    private func setConfiguration() {
        layer.masksToBounds = true
        backgroundColor = .black
        tintColor = .white
        addShadow(radius: 2)
    }

    func setValidStatus(status: MapStatus) {
        setImage(status.image, for: .normal)
    }
}
