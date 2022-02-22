//
//  SesacShopViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/21.
//

import Foundation
import RxCocoa
import RxSwift

final class SesacShopViewModel: ViewModelType {

    private weak var coordinator: SesacShopCoordinator?
    private let useCase: SesacShopUseCase

    struct Input {
        let viewDidLoad: Observable<Void>
        let sesacButtonTap: Signal<Void>
        let backgroundButtonTap: Signal<Void>
        let saveButtonTap: Signal<Void>
        let sesacItemTap: Signal<SesacImageCase>
        let backgroundItemTap: Signal<SesacBackgroundCase>
    }
    struct Output {
        let showSesacListAction: Signal<Void>
        let showBackgroundListAction: Signal<Void>
        let sesacCollectionList: Driver<[Int]>
        let backgroundCollectionList: Driver<[Int]>
        let profileSesac: Driver<SesacImageCase>
        let profileBackground: Driver<SesacBackgroundCase>
        let showToastAction: Signal<String>
    }
    var disposeBag = DisposeBag()

    private let showSesacListAction = PublishRelay<Void>()
    private let showBackgroundListAction = PublishRelay<Void>()
    private let sesacCollectionList = BehaviorRelay<[Int]>(value: [])
    private let backgroundCollectionList = BehaviorRelay<[Int]>(value: [])
    private let profileSesac = BehaviorRelay<SesacImageCase>(value: .sesac0)
    private let profileBackground = BehaviorRelay<SesacBackgroundCase>(value: .background0)
    private let showToastAction = PublishRelay<String>()

    init(coordinator: SesacShopCoordinator?, useCase: SesacShopUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.requestSesacShopInfo()
            })
            .disposed(by: disposeBag)

        input.sesacButtonTap
            .emit(to: showSesacListAction)
            .disposed(by: disposeBag)

        input.backgroundButtonTap
            .emit(to: showBackgroundListAction)
            .disposed(by: disposeBag)

        input.sesacItemTap
            .emit(to: profileSesac)
            .disposed(by: disposeBag)

        input.backgroundItemTap
            .emit(to: profileBackground)
            .disposed(by: disposeBag)

        input.saveButtonTap
            .map { [weak self] _ -> Bool in
                guard let self = self else { return false }
                let isHavingSesac = self.sesacCollectionList.value[self.profileSesac.value.rawValue] == 1 ? true : false
                let isHavingBackground = self.backgroundCollectionList.value[self.profileBackground.value.rawValue] == 1 ? true : false
                return isHavingSesac && isHavingBackground
            }
            .emit(onNext: { [weak self] isValid in
                guard let self = self else { return }
                if isValid {
                    self.requestUpdateShop(sesac: self.profileSesac.value, background: self.profileBackground.value)
                } else {
                    self.showToastAction.accept("구매가 필요한 아이템이 있어요")
                }
            })
            .disposed(by: disposeBag)

        self.useCase.successUpdateShop
            .asSignal()
            .emit(onNext: { [weak self] in
                self?.showToastAction.accept("성공적으로 저장되었습니다")
            })
            .disposed(by: disposeBag)

        self.useCase.successSesacShopInfo
            .asSignal()
            .emit(onNext: { [weak self] info in
                guard let self = self else { return }
                self.profileSesac.accept(info.sesac)
                self.profileBackground.accept(info.background)
                let sesacList = self.makeSesacList(sesacCollection: info.sesacCollection)
                let backgroundList = self.makeBackgroundList(backgroundCollection: info.backgroundCollection)
                self.sesacCollectionList.accept(sesacList)
                self.backgroundCollectionList.accept(backgroundList)
                self.showSesacListAction.accept(())
            })
            .disposed(by: disposeBag)

        return Output(
            showSesacListAction: showSesacListAction.asSignal(),
            showBackgroundListAction: showBackgroundListAction.asSignal(),
            sesacCollectionList: sesacCollectionList.asDriver(),
            backgroundCollectionList: backgroundCollectionList.asDriver(),
            profileSesac: profileSesac.asDriver(),
            profileBackground: profileBackground.asDriver(),
            showToastAction: showToastAction.asSignal()
        )
    }
}

extension SesacShopViewModel {

    private func makeSesacList(sesacCollection: [Int]) -> [Int] {
        return SesacImageCase.allCases.map { sesacCollection.contains($0.rawValue) ? 1 : 0 }
    }

    private func makeBackgroundList(backgroundCollection: [Int]) -> [Int] {
        return SesacBackgroundCase.allCases.map { backgroundCollection.contains($0.rawValue) ? 1 : 0 }
    }

    private func requestSesacShopInfo() {
        self.useCase.requestSesacShopInfo()
    }

    private func requestUpdateShop(sesac: SesacImageCase, background: SesacBackgroundCase) {
        self.useCase.requestUpdateShop(sesac: sesac, background: background)
    }
}
