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
        let backBarButtonTap : Signal<Void>
        let pauseSearchBarButtonTap: Signal<Void>
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
        input.pauseSearchBarButtonTap
            .emit(onNext: { [weak self] in
                self?.requestPauseSearchSesac()
            })
            .disposed(by: disposeBag)

        input.backBarButtonTap
            .emit(onNext: { [weak self] in
                self?.coordinator?.popToRootViewController()
            })
            .disposed(by: disposeBag)

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

        self.useCase.successPauseSearchSesac
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.coordinator?.popToRootViewController(message: "새싹 찾기가 중단되었습니다.")
            })
            .disposed(by: disposeBag)

        return Output(
            hobbyItems: hobbyItems.asDriver(),
            receivedRequestItems: receivedRequestItems.asDriver(),
            nearSecacButtonSelectedAction: nearSecacButtonSelectedAction.asSignal(),
            receivedRequestButtonSelectedAction: receivedRequestButtonSelectedAction.asSignal()
        )
    }
}

extension HobbySearchViewModel {

    func requestPauseSearchSesac() {
        self.useCase.requestPauseSearchSesac()
    }

}
