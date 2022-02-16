//
//  SearchSesacRequestDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/11.
//

import Foundation

struct SearchSesacRequestDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "type": 2,
            "region": region,
            "lat": lat,
            "long": long,
            "hf": hobbys
        ]
        return dict
    }

    var region: Int {
        let computedLat = Int((lat + 90.0) * 100)
        let computedLng = Int((long + 180.0) * 100)
        let computedTotal = "\(computedLat)\(computedLng)" as NSString
        return computedTotal.integerValue
    }
    let type: Int
    let long: Double
    let lat: Double
    let hobbys: [String]

    init(searchSesac: SearchSesacQuery) {
        self.type = searchSesac.type.value
        self.long = searchSesac.coordinate.longitude
        self.lat = searchSesac.coordinate.latitude
        self.hobbys = searchSesac.hobbys
    }
}
