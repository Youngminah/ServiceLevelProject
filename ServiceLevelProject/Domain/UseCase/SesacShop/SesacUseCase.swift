//
//  SesacUseCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import Foundation
import RxSwift
import RxRelay

final class SesacUseCase {

    private let userRepository: UserRepositoryType
    private let fireBaseRepository: FirbaseRepositoryType
    private let sesacRepository: SesacRepositoryType
    private let inAppRepository: InAppRepositoryType

    let successRequestReceipt = PublishRelay<String>()
    let successRequestProduct = PublishRelay<Void>()
    let successPurchaseProduct = PublishRelay<Void>()
    let failInAppService = PublishRelay<InAppManagerError>()
    var unKnownErrorSignal = PublishRelay<Void>()

    init(
        userRepository: UserRepositoryType,
        fireBaseRepository: FirbaseRepositoryType,
        sesacRepository: SesacRepositoryType,
        inAppRepository: InAppRepositoryType
    ) {
        self.userRepository = userRepository
        self.fireBaseRepository = fireBaseRepository
        self.sesacRepository = sesacRepository
        self.inAppRepository = inAppRepository
    }
}

extension SesacUseCase {

    func requestProductData(productIdentifiers: [String]) {
        self.inAppRepository.requestProductData(productIdentifiers: productIdentifiers) { [weak self] response in
            switch response {
            case .success():
                self?.successRequestProduct.accept(())
            case .failure(let error):
                self?.failInAppService.accept(error)
            }
        }
    }

    func requestPayment(index: Int) {
        self.inAppRepository.requestPayment(index: index) { [weak self] response in
            switch response {
            case .success(let receipt):
                self?.successRequestReceipt.accept(receipt)
            case .failure(let error):
                self?.failInAppService.accept(error)
            }
        }
    }
}

extension SesacUseCase {

    func requestPurchaseItem(receipt: String, sesac: SesacImageCase) {
        let itemQuery = PurchaseItemQuery(receipt: receipt, product: sesac.identifier)
        self.sesacRepository.requestPurchaseItem(itemQuery: itemQuery) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(_):
                self.successPurchaseProduct.accept(())
            case .failure(let error):
                switch error {
                case .inValidIDTokenError:
                    self.requestIDToken {
                        self.requestPurchaseItem(receipt: receipt, sesac: sesac)
                    }
                default:
                    self.unKnownErrorSignal.accept(())
                }
            }
        }
    }
}

extension SesacUseCase {

    private func requestIDToken(completion: @escaping () -> Void) {
        fireBaseRepository.requestIdtoken { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let idToken):
                print("재발급 성공--> \(idToken)")
                self.saveIdTokenInfo(idToken: idToken)
                completion()
            case .failure(let error):
                print(error.description)
                self.logoutUserInfo()
                self.unKnownErrorSignal.accept(())
            }
        }
    }
}

extension SesacUseCase {

    private func saveIdTokenInfo(idToken: String) {
        self.userRepository.saveIdTokenInfo(idToken: idToken)
    }

    private func logoutUserInfo() {
        self.userRepository.logoutUserInfo()
    }
}
