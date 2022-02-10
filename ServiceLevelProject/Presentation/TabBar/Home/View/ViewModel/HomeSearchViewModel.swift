//
//  HobbySetViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/09.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

final class HomeSearchViewModel: ViewModelType {

    private weak var coordinator: HomeCoordinator?
    private let useCase: HomeSearchUseCase
    private let userCoordinate: Coordinate

    struct Input {
        let viewWillAppearSignal: Signal<Void>
        let searhBarTapWithText: Signal<String>
        let itemSelectedSignal: Signal<HobbyItem>
    }
    struct Output {
        let hobbyItems: Driver<[HobbySectionModel]>
        let removeSearchBarTextAction: Signal<Void>
        let showToastAction: Signal<String>
        let indicatorAction: Driver<Bool>
    }
    var disposeBag = DisposeBag()

    private let hobbyItems = BehaviorRelay<[HobbySectionModel]>(value: [])
    private let removeSearchBarTextAction = PublishRelay<Void>()
    private let showToastAction = PublishRelay<String>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)

    init(coordinator: HomeCoordinator?, useCase: HomeSearchUseCase, coordinate: Coordinate) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.userCoordinate = coordinate
    }

    func transform(input: Input) -> Output {
        input.viewWillAppearSignal
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.indicatorAction.accept(true)
                self.requestOnqueue(coordinate: self.userCoordinate)
            })
            .disposed(by: disposeBag)

        input.searhBarTapWithText
            .do { [weak self] _ in
                self?.removeSearchBarTextAction.accept(())
            }
            .map(validationSearchText)
            .emit(onNext: { [weak self] isvalid, text in
                guard let self = self else { return }
                if isvalid {
                    let selectedItem = HobbyItem.selected(Hobby(content: text))
                    self.addSelectedItem(selectedItem: selectedItem)
                } else {
                    self.showToastAction.accept(ToastCase.inValidSelectedHobbyTextCount.errorDescription)
                }
            })
            .disposed(by: disposeBag)

        input.itemSelectedSignal
            .emit(onNext: { [weak self] item in
                guard let self = self else { return }
                switch item {
                case .near(let hobby):
                    let selectedItem = HobbyItem.selected(hobby)
                    self.addSelectedItem(selectedItem: selectedItem)
                case .selected(_):
                    var items = self.hobbyItems.value
                    if let index = items[1].items.firstIndex(of: item) {
                        items[1].items.remove(at: index)
                    }
                    self.hobbyItems.accept(items)
                    return
                }
            })
            .disposed(by: disposeBag)

        useCase.successOnqueueSignal
            .asSignal()
            .emit(onNext: { [weak self] response in
                guard let self = self else { return }
                let section = response.map { HobbyItem.near($0) }
                let sections = [
                    HobbySectionModel(model: .near, items: section),
                    HobbySectionModel(model: .selected, items: [])
                ]
                self.hobbyItems.accept(sections)
            })
            .disposed(by: disposeBag)

        Observable.merge(
            useCase.successOnqueueSignal.map { _ in () },
            useCase.unKnownErrorSignal.asObservable()
        )
            .asDriver(onErrorJustReturn: ())
            .map { _ in false }
            .drive(indicatorAction)
            .disposed(by: disposeBag)
        
        return Output(
            hobbyItems: hobbyItems.asDriver(),
            removeSearchBarTextAction: removeSearchBarTextAction.asSignal(),
            showToastAction: showToastAction.asSignal(),
            indicatorAction: indicatorAction.asDriver()
        )
    }
}

extension HomeSearchViewModel {

    private func validationSearchText(text: String) -> (Bool, String) {
        return (text.count <= 8, text)
    }

    private func addSelectedItem(selectedItem: HobbyItem) {
        var items = self.hobbyItems.value
        if items[1].items.count >= 8 {
            self.showToastAction.accept(ToastCase.limitSelectedHobbyCount.errorDescription)
        } else if items[1].items.contains(selectedItem) {
            self.showToastAction.accept(ToastCase.duplicatedSelectedHobby.errorDescription)
        } else {
            items[1].items.append(selectedItem)
            self.hobbyItems.accept(items)
        }
    }

    private func requestOnqueue(coordinate: Coordinate) {
        self.useCase.requestOnqueue(coordinate: coordinate)
    }
}
