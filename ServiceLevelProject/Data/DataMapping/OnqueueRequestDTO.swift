//
//  OnqueueRequestDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/07.
//

import Foundation

struct OnqueueRequestDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "region": region,
            "lat": lat,
            "long": long,
        ]
        return dict
    }

    var region: Int {
        let computedLat = Int((lat + 90.0) * 100)
        let computedLng = Int((long + 180.0) * 100)
        let computedTotal = "\(computedLat)\(computedLng)" as NSString
        return computedTotal.integerValue
    }
    let lat: Double
    let long: Double

    init(userLocationInfo: Coordinate) {
        self.lat = userLocationInfo.latitude
        self.long = userLocationInfo.longitude
    }
}
