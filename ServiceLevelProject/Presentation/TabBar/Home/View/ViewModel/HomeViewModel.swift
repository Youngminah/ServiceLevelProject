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

final class HomeViewModel: ViewModelType {

    private weak var coordinator: HomeCoordinator?
    private let homeUseCase: HomeUseCase

    struct Input {
        let genderFilterInfo: Observable<GenderCase>
        let requestOnqueueInfo: Observable<Coordinate>
        let myLocationButtonTap: Signal<Void>
        let isAutorizedLocation: Signal<Bool>
        let mapStatusButtonTap: Signal<Void>
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

        input.mapStatusButtonTap
            .emit(onNext: { [weak self] _ in
                self?.coordinator?.showHobbySetViewController()
            })
            .disposed(by: disposeBag)

        Observable.of(
            input.genderFilterInfo.withLatestFrom(input.requestOnqueueInfo),
            input.requestOnqueueInfo)
            .merge()
            .skip(1)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] coordinate in
                self?.requestOnqueue(coordinate: coordinate)
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(
            homeUseCase.successOnqueueSignal,
            input.genderFilterInfo,
            resultSelector: filterSesacDB )
            .bind(onNext: { [weak self] list in
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

    private func filterSesacDB(nearSesacDB: NearSesacDBInfo, gender: GenderCase) -> [SesacDB] {
        switch gender {
        case .total:
            return nearSesacDB.fromSesacDB + nearSesacDB.fromSesacDBRequested
        case .woman:
            return nearSesacDB.fromSesacDB.filter { $0.gender == .woman } + nearSesacDB.fromSesacDBRequested.filter { $0.gender == .woman }
        case .man:
            return nearSesacDB.fromSesacDB.filter { $0.gender == .man } + nearSesacDB.fromSesacDBRequested.filter { $0.gender == .man }
        }
    }

    private func requestOnqueue(coordinate: Coordinate) {
        self.homeUseCase.requestOnqueue(coordinate: coordinate)
    }
}