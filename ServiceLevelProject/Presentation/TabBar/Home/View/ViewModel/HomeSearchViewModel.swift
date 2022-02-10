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

    }
    struct Output {

    }
    var disposeBag = DisposeBag()

    init(coordinator: HomeCoordinator?, homeUseCase: HomeUseCase) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }

    func transform(input: Input) -> Output {

        return Output(

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
