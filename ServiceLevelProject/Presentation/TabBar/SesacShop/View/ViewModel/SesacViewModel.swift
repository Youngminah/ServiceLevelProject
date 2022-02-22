//
//  SesacViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import Foundation
import RxCocoa
import RxSwift

final class SesacViewModel: ViewModelType {

    private let useCase: SesacUseCase

    struct Input {
        let viewDidLoad: Observable<Void>
        let priceButtonTap: Signal<Int>
    }
    struct Output {
        let sesacLists: Driver<[SesacImageCase]>
        let successPurchaseProduct: Signal<SesacImageCase>
        let indicatorAction: Driver<Bool>
    }
    var disposeBag = DisposeBag()

    private let sesacLists = BehaviorRelay<[SesacImageCase]>(value: SesacImageCase.allCases)
    private let indicatorAction = BehaviorRelay<Bool>(value: false)
    private let successPurchaseProduct = PublishRelay<SesacImageCase>()

    private var purchaseSesac: SesacImageCase = .sesac0

    init(useCase: SesacUseCase) {
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {

        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                var ids = SesacImageCase.allCases.map { $0.identifier }
                ids.removeFirst()
                self?.requestProductData(productIdentifiers: ids)
            })
            .disposed(by: disposeBag)

        input.priceButtonTap
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }
                self.indicatorAction.accept(true)
                self.requestPayment(index: index)
                self.purchaseSesac = SesacImageCase(value: index)
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
                self.requestPurchaseItem(receipt: receipt, sesac: self.purchaseSesac)
            })
            .disposed(by: disposeBag)

        self.useCase.successPurchaseProduct
            .asSignal()
            .emit(onNext: { [weak self] in
                print("영수증 인증까지 성공!!")
                guard let self = self else { return }
                self.successPurchaseProduct.accept(self.purchaseSesac)
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
            sesacLists: sesacLists.asDriver(),
            successPurchaseProduct: successPurchaseProduct.asSignal(),
            indicatorAction: indicatorAction.asDriver()
        )
    }
}

extension SesacViewModel {

    private func requestProductData(productIdentifiers: [String]) {
        self.useCase.requestProductData(productIdentifiers: productIdentifiers)
    }

    private func requestPayment(index: Int) {
        self.useCase.requestPayment(index: index)
    }

    private func requestPurchaseItem(receipt: String, sesac: SesacImageCase) {
        self.useCase.requestPurchaseItem(receipt: receipt, sesac: sesac)
    }
}
