//
//  BackgroundUseCase.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import Foundation
import RxSwift
import RxRelay

final class BackgroundUseCase {

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

extension BackgroundUseCase {

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

extension BackgroundUseCase {

    func requestPurchaseItem(receipt: String, background: SesacBackgroundCase) {
        let itemQuery = PurchaseItemQuery(receipt: receipt, product: background.identifier)
        self.sesacRepository.requestPurchaseItem(itemQuery: itemQuery) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(_):
                self.successPurchaseProduct.accept(())
            case .failure(let error):
                switch error {
                case .inValidIDTokenError:
                    self.requestIDToken {
                        self.requestPurchaseItem(receipt: receipt, background: background)
                    }
                default:
                    self.unKnownErrorSignal.accept(())
                }
            }
        }
    }
}

extension BackgroundUseCase {

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

extension BackgroundUseCase {

    private func saveIdTokenInfo(idToken: String) {
        self.userRepository.saveIdTokenInfo(idToken: idToken)
    }

    private func logoutUserInfo() {
        self.userRepository.logoutUserInfo()
    }
}
