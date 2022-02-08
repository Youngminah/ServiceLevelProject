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
    private let homeUseCase: HomeUseCase

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
