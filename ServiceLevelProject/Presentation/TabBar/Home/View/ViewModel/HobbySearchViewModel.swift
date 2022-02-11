//
//  HobbySearchViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/11.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay

final class HobbySearchViewModel: ViewModelType {

    private weak var coordinator: HomeCoordinator?
    private let useCase: HobbySearchUseCase
    private let userCoordinate: Coordinate

    struct Input {
        let viewWillAppear: Signal<Void>
        let nearSesacButtonTap: Signal<Void>
        let receivedRequestButtonTap: Signal<Void>
    }
    struct Output {
        let hobbyItems: Driver<[String]>
        let receivedRequestItems: Driver<[String]>
        let nearSecacButtonSelectedAction: Signal<Void>
        let receivedRequestButtonSelectedAction: Signal<Void>
    }
    var disposeBag = DisposeBag()

    private let hobbyItems = BehaviorRelay<[String]>(value: [])
    private let receivedRequestItems = BehaviorRelay<[String]>(value: [])
    private let nearSecacButtonSelectedAction = PublishRelay<Void>()
    private let receivedRequestButtonSelectedAction = PublishRelay<Void>()

    init(coordinator: HomeCoordinator?, useCase: HobbySearchUseCase, coordinate: Coordinate) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.userCoordinate = coordinate
    }

    func transform(input: Input) -> Output {

        input.viewWillAppear
            .map({ () in
                return []
            })
            .emit(to: hobbyItems)
            .disposed(by: disposeBag)

        input.nearSesacButtonTap
            .map({ [weak self] _ in
                self?.nearSecacButtonSelectedAction.accept(())
                return []
            })
            .emit(to: hobbyItems)
            .disposed(by: disposeBag)

        input.receivedRequestButtonTap
            .map({ [weak self] _ in
                self?.receivedRequestButtonSelectedAction.accept(())
                return []
            })
            .emit(to: receivedRequestItems)
            .disposed(by: disposeBag)

        return Output(
            hobbyItems: hobbyItems.asDriver(),
            receivedRequestItems: receivedRequestItems.asDriver(),
            nearSecacButtonSelectedAction: nearSecacButtonSelectedAction.asSignal(),
            receivedRequestButtonSelectedAction: receivedRequestButtonSelectedAction.asSignal()
        )
    }
}

extension HomeSearchViewModel {

}
