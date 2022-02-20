//
//  SesacViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import Foundation
import RxCocoa
import RxSwift

final class SesacViewModel: ViewModelType {

    private weak var coordinator: SesacShopCoordinator?
    private let useCase: SesacUseCase

    struct Input {

    }
    struct Output {

    }
    var disposeBag = DisposeBag()


    init(coordinator: SesacShopCoordinator?, useCase: SesacUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {

        return Output(

        )
    }
}
