//
//  MyPageEditViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import Foundation
import Moya
import RxCocoa
import RxSwift
import Toast

final class MyPageEditViewModel: ViewModelType {

    private weak var coordinator: MyPageCoordinator?
    private let myPageEditUseCase: MyPageEditUseCase

    struct Input {
        let didWithdrawButtonTap: Signal<Void>
        let requestWithdrawSignal: Signal<Void>
    }
    struct Output {
        let showAlertAction: Signal<Void>
        let indicatorAction: Driver<Bool>
    }
    var disposeBag = DisposeBag()

    private let showAlertAction = PublishRelay<Void>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)

    init(coordinator: MyPageCoordinator?, myPageEditUseCase: MyPageEditUseCase) {
        self.coordinator = coordinator
        self.myPageEditUseCase = myPageEditUseCase
    }

    func transform(input: Input) -> Output {

        input.didWithdrawButtonTap
            .emit(onNext: { [weak self] in
                self?.showAlertAction.accept(())
            })
            .disposed(by: disposeBag)

        input.requestWithdrawSignal
            .emit(onNext: { [weak self] in
                self?.indicatorAction.accept(true)
                self?.requestWithdraw()
            })
            .disposed(by: disposeBag)

        myPageEditUseCase.successWithdrawSignal
            .asSignal()
            .emit(onNext: { [weak self] in
                self?.indicatorAction.accept(false)
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        myPageEditUseCase.failWithdrawSignal
            .asSignal()
            .emit(onNext: { [weak self] error in
                self?.indicatorAction.accept(false)
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        myPageEditUseCase.failFirebaseFlowSignal
            .asSignal()
            .emit(onNext: { [weak self] error in
                self?.indicatorAction.accept(false)
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        return Output(
            showAlertAction: showAlertAction.asSignal(),
            indicatorAction: indicatorAction.asDriver()
        )
    }
}

extension MyPageEditViewModel {

    private func requestWithdraw() {
        self.myPageEditUseCase.requestWithdraw()
    }
}
