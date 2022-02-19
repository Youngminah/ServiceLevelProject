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
        let requestSesacFriend: Signal<String>
        let requestAcceptSesacFriend: Signal<String>
        let reviewDetailButtonTap: Signal<Int>
        let changeHobbyButtonTap: Signal<Void>
        let refreshButtonTap: Signal<Void>
    }
    struct Output {
        let items: Driver<[HobbySearchItemViewModel]>
        let tabStatus: Driver<SearchSesacTab>
        let nearSecacButtonSelectedAction: Signal<Void>
        let receivedRequestButtonSelectedAction: Signal<Void>
        let showToastAction: Signal<String>
        let indicatorAction: Driver<Bool>
    }
    var disposeBag = DisposeBag()

    private let items = BehaviorRelay<[HobbySearchItemViewModel]>(value: [])
    private let nearSecacButtonSelectedAction = PublishRelay<Void>()
    private let receivedRequestButtonSelectedAction = PublishRelay<Void>()
    private let tabStatus = BehaviorRelay<SearchSesacTab>(value: .near)
    private let showToastAction = PublishRelay<String>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)

    init(coordinator: HomeCoordinator?, useCase: HobbySearchUseCase, coordinate: Coordinate) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.userCoordinate = coordinate
    }

    func transform(input: Input) -> Output {
        input.refreshButtonTap
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.indicatorAction.accept(true)
                self.requestOnqueue()
            })
            .disposed(by: disposeBag)

        input.changeHobbyButtonTap
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.requestPauseSearchSesac()
            })
            .disposed(by: disposeBag)

        input.pauseSearchBarButtonTap
            .emit(onNext: { [weak self] in
                self?.indicatorAction.accept(true)
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
                self.tabStatus.accept(.near)
                self.nearSecacButtonSelectedAction.accept(())
                self.indicatorAction.accept(true)
                self.requestOnqueue()
            })
            .disposed(by: disposeBag)

        input.receivedRequestButtonTap
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.tabStatus.accept(.receive)
                self.receivedRequestButtonSelectedAction.accept(())
                self.indicatorAction.accept(true)
                self.requestOnqueue()
            })
            .disposed(by: disposeBag)

        input.requestSesacFriend
            .emit(onNext: { [weak self] userID in
                guard let self = self else { return }
                let alert = AlertView.init(
                    title: SearchSesacTab.near.alertTitle,
                    message: SearchSesacTab.near.alertMessage,
                    buttonStyle: .confirmAndCancel) {
                        self.indicatorAction.accept(true)
                        self.requestSesacFriend(userID: userID)
                    }
                alert.showAlert()
            })
            .disposed(by: disposeBag)

        input.requestAcceptSesacFriend
            .emit(onNext: { [weak self] userID in
                guard let self = self else { return }
                let alert = AlertView.init(
                    title: SearchSesacTab.receive.alertTitle,
                    message: SearchSesacTab.receive.alertMessage,
                    buttonStyle: .confirmAndCancel) {
                        self.indicatorAction.accept(true)
                        self.requestAcceptSesacFriend(userID: userID)
                    }
                alert.showAlert()
            })
            .disposed(by: disposeBag)

        input.reviewDetailButtonTap
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }
                self.coordinator?.showReviewDetailViewController(reviews: self.items.value[index].reviews)
            })
            .disposed(by: disposeBag)

        self.useCase.alreadyMatchedErrorSignal
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.indicatorAction.accept(false)
                //사용자 본인상태 확인 API
                self?.showToastAction.accept("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!")
                self?.requestMyQueueState()
            })
            .disposed(by: disposeBag)

        self.useCase.successRequestMyQueueState
            .asSignal()
            .emit(onNext: { [weak self] state in
                print("My Queue State -->", state)
                if state.dodged == 1 || state.reviewed == 1 {
                    self?.showToastAction.accept("약속이 종료되어 채팅을 보낼 수 없습니다")
                } else if state.matched == 1 {
                    self?.coordinator?.navigationController.view.makeToast("dks", duration: 1, position: .top, completion: { didTap in
                        self?.coordinator?.showChatViewController()
                    })
                }
            })
            .disposed(by: disposeBag)

        self.useCase.successPauseSearchSesac
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.indicatorAction.accept(false)
                self?.coordinator?.popToRootViewController(message: "새싹 찾기가 중단되었습니다.")
            })
            .disposed(by: disposeBag)

        self.useCase.successRequestSesacFriend
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.showToastAction.accept(SearchSesacTab.near.toastMessage)
                self?.indicatorAction.accept(false)
            })
            .disposed(by: disposeBag)

        self.useCase.successAcceptSesacFriend
            .asSignal()
            .emit(onNext: { [weak self] _ in
                print("수락하였습니다. 채팅화면 이동!!")
                self?.indicatorAction.accept(false)
                self?.coordinator?.showChatViewController()
            })
            .disposed(by: disposeBag)

        self.useCase.unKnownErrorSignal
            .asSignal()
            .emit(onNext: { [weak self] error in
                self?.indicatorAction.accept(false)
                print(error)
            })
            .disposed(by: disposeBag)

        self.useCase.successOnqueueSignal
            .bind(onNext: { [weak self] onqueue in
                guard let self = self else { return }
                switch self.tabStatus.value {
                case .near:
                    let items = self.makeNearSesacItem(onqueue: onqueue)
                    self.items.accept(items)
                case .receive:
                    let items = self.makeReceivedRequestItem(onqueue: onqueue)
                    self.items.accept(items)
                }
                self.indicatorAction.accept(false)
            })
            .disposed(by: disposeBag)

        return Output(
            items: items.asDriver(),
            tabStatus: tabStatus.asDriver(),
            nearSecacButtonSelectedAction: nearSecacButtonSelectedAction.asSignal(),
            receivedRequestButtonSelectedAction: receivedRequestButtonSelectedAction.asSignal(),
            showToastAction: showToastAction.asSignal(),
            indicatorAction: indicatorAction.asDriver()
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

    private func requestSesacFriend(userID: String) {
        self.useCase.requestSesacFriend(userID: userID)
    }

    private func requestAcceptSesacFriend(userID: String) {
        self.useCase.requestAcceptSesacFriend(userID: userID)
    }

    private func requestMyQueueState() {
        self.useCase.requestMyQueueState()
    }
}
