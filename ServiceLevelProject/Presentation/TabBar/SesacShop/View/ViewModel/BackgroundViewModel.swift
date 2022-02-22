//
//  BackgroundViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import Foundation
import RxCocoa
import RxSwift

final class BackgroundViewModel: ViewModelType {

    private let useCase: BackgroundUseCase

    struct Input {
        let viewDidLoad: Observable<Void>
        let priceButtonTap: Signal<Int>
    }
    struct Output {
        let backgroundLists: Driver<[SesacBackgroundCase]>
        let successPurchaseProduct: Signal<SesacBackgroundCase>
        let indicatorAction: Driver<Bool>
    }
    var disposeBag = DisposeBag()

    private let backgroundLists = BehaviorRelay<[SesacBackgroundCase]>(value: SesacBackgroundCase.allCases)
    private let indicatorAction = BehaviorRelay<Bool>(value: false)
    private let successPurchaseProduct = PublishRelay<SesacBackgroundCase>()

    private var purchaseBackground: SesacBackgroundCase = .background0

    init(useCase: BackgroundUseCase) {
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {

        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                var ids = SesacBackgroundCase.allCases.map { $0.identifier }
                ids.removeFirst()
                self?.requestProductData(productIdentifiers: ids)
            })
            .disposed(by: disposeBag)

        input.priceButtonTap
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }
                print("눌림?")
                self.indicatorAction.accept(true)
                self.requestPayment(index: index)
                self.purchaseBackground = SesacBackgroundCase(value: index)
            })
            .disposed(by: disposeBag)

        self.useCase.successRequestProduct
            .asSignal()
            .emit(onNext: { [weak self] in

            })
            .disposed(by: disposeBag)

        self.useCase.successRequestReceipt
            .asSignal()
            .emit(onNext: { [weak self] receipt in
                print("성공!!-->", receipt)
                guard let self = self else { return }
                self.requestPurchaseItem(receipt: receipt, background: self.purchaseBackground)
            })
            .disposed(by: disposeBag)

        self.useCase.successPurchaseProduct
            .asSignal()
            .emit(onNext: { [weak self] in
                print("영수증 인증까지 성공!!")
                guard let self = self else { return }
                self.successPurchaseProduct.accept(self.purchaseBackground)
                self.indicatorAction.accept(false)
            })
            .disposed(by: disposeBag)

        self.useCase.failInAppService
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.indicatorAction.accept(false)
            })
            .disposed(by: disposeBag)

        return Output(
            backgroundLists: backgroundLists.asDriver(),
            successPurchaseProduct: successPurchaseProduct.asSignal(),
            indicatorAction: indicatorAction.asDriver()
        )
    }
}

extension BackgroundViewModel {

    private func requestProductData(productIdentifiers: [String]) {
        self.useCase.requestProductData(productIdentifiers: productIdentifiers)
    }

    private func requestPayment(index: Int) {
        let sesecProductsCount = SesacImageCase.allCases.count - 1
        self.useCase.requestPayment(index: sesecProductsCount + index)
    }

    private func requestPurchaseItem(receipt: String, background: SesacBackgroundCase) {
        self.useCase.requestPurchaseItem(receipt: receipt, background: background)
    }
}
