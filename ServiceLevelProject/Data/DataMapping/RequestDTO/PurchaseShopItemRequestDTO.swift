//
//  PurchaseShopItemRequestDTO.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/22.
//

import Foundation

struct PurchaseShopItemRequestDTO: Codable {

    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "receipt": receipt,
            "product": product
        ]
        return dict
    }

    let receipt: String
    let product: String

    init(itemInfo: PurchaseItemQuery) {
        receipt = itemInfo.receipt
        product = itemInfo.product
    }
}
