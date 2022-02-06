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

    let region: Int
    let lat: Double
    let long: Double

    init(userLocationInfo: UserLocationInfo) {
        self.region = Int(userLocationInfo.latitude)
        self.lat = userLocationInfo.latitude
        self.long = userLocationInfo.longitude
    }
}
