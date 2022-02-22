//
//  StoreManager.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/21.
//

import Foundation
import StoreKit

enum InAppManagerError: Error {
    case noProductIDsFound
    case noProductsFound
    case paymentWasCancelled
    case productRequestFailed
    case impossiblePaymant
    case onReceiptEncodingFailed
}

final class InAppManager: NSObject {

    static let shared = InAppManager()

    private var productArray = [SKProduct]()

    var onReceiveProductsHandler: ((Result<[SKProduct], InAppManagerError>) -> Void)?
    var onPaymentTransactionHandler: ((Result<String, InAppManagerError>) -> Void)?
}

extension InAppManager {

    func requestPayment(index: Int) {
        let payment = SKPayment(product: productArray[index - 1])
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }
}

extension InAppManager: SKProductsRequestDelegate {

    func requestProductData(productIdentifiers: Set<String>) {
        print(productIdentifiers)
        if SKPaymentQueue.canMakePayments() {
            print("인앱 결제 가능")
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            print("인앱 결제 불가능")
            onReceiveProductsHandler?(.failure(.impossiblePaymant))
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        if products.count > 0 {
            productArray = products
            for i in products {
                print("앱스토어에서 만들어 놓은 상품: ", i.localizedTitle, i.price, i.priceLocale, i.localizedDescription)
            }
            onReceiveProductsHandler?(.success(products))
        } else {
            onReceiveProductsHandler?(.failure(.noProductsFound))
        }
    }
}

extension InAppManager: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased: //구매 승인 이후에 영수증 검증 절차가 들어감
                print("Transaction Approved. \(transaction.payment.productIdentifier)")
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
            case .failed: //실패시 토스트, transaction에서 상품제거
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            @unknown default:
                break
            }
        }
    }

    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        guard let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) else {
            onPaymentTransactionHandler?(.failure(.onReceiptEncodingFailed))
            return
        }
        print(receiptString)
        onPaymentTransactionHandler?(.success(receiptString))
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    //목록이 많아질 경우
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("removedTransactions")
    }
}
