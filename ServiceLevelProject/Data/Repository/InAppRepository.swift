//
//  InAppRepository.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/21.
//

import Foundation

final class InAppRepository: InAppRepositoryType {

    var manager: InAppManager

    init() {
        self.manager = InAppManager.shared
    }
}

extension InAppRepository {

    func requestPayment(index: Int, completion: @escaping ( Result<String, InAppManagerError>) -> Void) {
        self.manager.onPaymentTransactionHandler = { response in
            print(response)
            DispatchQueue.main.async {
                completion(response)
            }
        }
        self.manager.requestPayment(index: index)
    }

    func requestProductData(productIdentifiers: [String], completion: @escaping ( Result<Void, InAppManagerError>) -> Void) {
        self.manager.onReceiveProductsHandler = { response in
            DispatchQueue.main.async {
                switch response {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.manager.requestProductData(productIdentifiers: Set(productIdentifiers))
    }

}
