//
//  BirthViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

final class BirthViewModel: ViewModelType {

    private weak var coordinator: NickNameCoordinator?

    struct Input {
        let signInFirebaseSignal: Signal<String>
    }
    struct Output {
    }
    var disposeBag = DisposeBag()

    init(coordinator: NickNameCoordinator?) {
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {



        return Output(
        )
    }
}
