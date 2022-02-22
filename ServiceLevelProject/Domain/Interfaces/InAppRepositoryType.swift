//
//  InAppRepositoryType.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/22.
//

import Foundation

protocol InAppRepositoryType: AnyObject {

    func requestPayment(
        index: Int,
        completion: @escaping (                //앱스토어 인앱결제 요청
            Result< String,
            InAppManagerError>
        ) -> Void
    )

    func requestProductData(                   //앱스토어 Product 불러오기
        productIdentifiers: [String],
        completion: @escaping (
            Result< Void,
            InAppManagerError>
        ) -> Void
    )
}
