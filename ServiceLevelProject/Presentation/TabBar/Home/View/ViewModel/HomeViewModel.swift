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
        let isAutorizedLocation: Signal<Bool>
        let requestOnqueueInfo: Signal<Coordinate>
    }
    struct Output {
        let confirmAuthorizedLocation: Signal<Void>
        let updateLocationAction: Signal<Void>
        let unAutorizedLocationAlert: Signal<(String, String)>
        let onqueueList: Signal<[SesacDB]>
    }
    var disposeBag = DisposeBag()

    private let confirmAuthorizedLocation = PublishRelay<Void>()
    private let updateLocationAction = PublishRelay<Void>()
    private let unAutorizedLocationAlert = PublishRelay<(String, String)>()
    private let onqueueList = PublishRelay<[SesacDB]>()

    init(coordinator: HomeCoordinator?, homeUseCase: HomeUseCase) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }

    func transform(input: Input) -> Output {

        input.myLocationButtonTap
            .throttle(.seconds(1), latest: false)
            .emit(onNext: { [weak self] _ in
                self?.confirmAuthorizedLocation.accept(())
            })
            .disposed(by: disposeBag)

        input.isAutorizedLocation
            .emit(onNext: { [weak self] isEnable in
                guard let self = self else { return }
                if isEnable {
                    self.updateLocationAction.accept(())
                } else {
                    self.unAutorizedLocationAlert.accept(("위치 서비스 사용 불가", "아이폰 설정으로 이동합니다."))
                }
            })
            .disposed(by: disposeBag)

        input.requestOnqueueInfo
            .skip(1)
            .throttle(.seconds(1), latest: false)
            .emit(onNext: { [weak self] coordinate in
                self?.requestOnqueue(coordinate: coordinate)
            })
            .disposed(by: disposeBag)

        homeUseCase.successOnqueueSignal.asSignal()
            .emit(onNext: { [weak self] info in
                let list = info.fromSesacDB + info.fromSesacDBRequested
                self?.onqueueList.accept(list)
            })
            .disposed(by: disposeBag)

        return Output(
            confirmAuthorizedLocation: confirmAuthorizedLocation.asSignal(),
            updateLocationAction: updateLocationAction.asSignal(),
            unAutorizedLocationAlert: unAutorizedLocationAlert.asSignal(),
            onqueueList: onqueueList.asSignal()
        )
    }
}

extension HomeViewModel {

    private func requestOnqueue(coordinate: Coordinate) {
        self.homeUseCase.requestOnqueue(coordinate: coordinate)
    }
}
