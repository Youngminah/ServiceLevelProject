//
//  BackgroundViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import Foundation
import RxCocoa
import RxSwift

final class BackgroundViewModel: ViewModelType {

    private weak var coordinator: SesacShopCoordinator?
    private let useCase: BackgroundUseCase

    struct Input {

    }
    struct Output {

    }
    var disposeBag = DisposeBag()


    init(coordinator: SesacShopCoordinator?, useCase: BackgroundUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {

        return Output(

        )
    }
}
