//
//  HomeViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/05.
//

import Foundation
import Moya
import RxCocoa
import RxSwift
import Toast

final class HomeViewModel: ViewModelType {

    private weak var coordinator: HomeCoordinator?
    private let homeUseCase: HomeUseCase

    struct Input {
        let myLocationButtonTap: Signal<Void>
    }
    struct Output {
        let updateLocationAction: Signal<Void>
        let showToastAction: Signal<String>
        let indicatorAction: Driver<Bool>
    }
    var disposeBag = DisposeBag()

    private let updateLocationAction = PublishRelay<Void>()
    private let showToastAction = PublishRelay<String>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)

    init(coordinator: HomeCoordinator?, homeUseCase: HomeUseCase) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }

    func transform(input: Input) -> Output {

        input.myLocationButtonTap
            .throttle(.seconds(1), latest: false)
            .emit(onNext: { [weak self] _ in
                self?.updateLocationAction.accept(())
            })
            .disposed(by: disposeBag)

        return Output(
            updateLocationAction: updateLocationAction.asSignal(),
            showToastAction: showToastAction.asSignal(),
            indicatorAction: indicatorAction.asDriver()
        )
    }
}
