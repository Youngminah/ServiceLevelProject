//
//  UpdateShopRequestDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/21.
//

import Foundation

struct UpdateShopRequestDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "sesac": sesac,
            "background": background
        ]
        return dict
    }

    let sesac: Int
    let background: Int

    init(updateShop: UpdateShopQuery) {
        sesac = updateShop.sesac.rawValue
        background = updateShop.background.rawValue
    }
}
