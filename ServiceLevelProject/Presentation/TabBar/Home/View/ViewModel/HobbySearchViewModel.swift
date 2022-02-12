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
        let backBarButtonTap: Signal<Void>
        let pauseSearchBarButtonTap: Signal<Void>
        let nearSesacButtonTap: Signal<Void>
        let receivedRequestButtonTap: Signal<Void>
    }
    struct Output {
        let hobbyItems: Driver<[HobbySearchItemViewModel]>
        let receivedRequestItems: Driver<[HobbySearchItemViewModel]>
        let nearSecacButtonSelectedAction: Signal<Void>
        let receivedRequestButtonSelectedAction: Signal<Void>
    }
    var disposeBag = DisposeBag()

    private let hobbyItems = BehaviorRelay<[HobbySearchItemViewModel]>(value: [])
    private let receivedRequestItems = BehaviorRelay<[HobbySearchItemViewModel]>(value: [])
    private let nearSecacButtonSelectedAction = PublishRelay<Void>()
    private let receivedRequestButtonSelectedAction = PublishRelay<Void>()

    private let isSelectdNearSesacButton = BehaviorRelay<Bool>(value: true)

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
            .emit(onNext: { [weak self] in
                self?.requestOnqueue()
            })
            .disposed(by: disposeBag)

        input.nearSesacButtonTap
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.isSelectdNearSesacButton.accept(true)
                self.nearSecacButtonSelectedAction.accept(())
                self.requestOnqueue()
            })
            .disposed(by: disposeBag)

        input.receivedRequestButtonTap
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.isSelectdNearSesacButton.accept(false)
                self.receivedRequestButtonSelectedAction.accept(())
                self.requestOnqueue()
            })
            .disposed(by: disposeBag)

        self.useCase.successPauseSearchSesac
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.coordinator?.popToRootViewController(message: "새싹 찾기가 중단되었습니다.")
            })
            .disposed(by: disposeBag)

        Observable.zip(
            self.useCase.successOnqueueSignal,
            self.isSelectdNearSesacButton)
            .bind(onNext: { [weak self] onqueue, status in
                guard let self = self else { return }
                if status {
                    let items = self.makeNearSesacItem(onqueue: onqueue)
                    self.hobbyItems.accept(items)
                } else {
                    let items = self.makeReceivedRequestItem(onqueue: onqueue)
                    self.hobbyItems.accept(items)
                }
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

    private func makeNearSesacItem(onqueue: Onqueue) -> [HobbySearchItemViewModel] {
        return onqueue.fromSesacDB.map { HobbySearchItemViewModel(sesacDB: $0) }
    }

    private func makeReceivedRequestItem(onqueue: Onqueue) -> [HobbySearchItemViewModel] {
        return onqueue.fromSesacDBRequested.map { HobbySearchItemViewModel(sesacDB: $0) }
    }

    private func requestPauseSearchSesac() {
        self.useCase.requestPauseSearchSesac()
    }

    private func requestOnqueue() {
        self.useCase.requestOnqueue(coordinate: userCoordinate)
    }
}
