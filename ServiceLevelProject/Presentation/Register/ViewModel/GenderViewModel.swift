//
//  GenderViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

final class GenderViewModel: CommonViewModel, ViewModelType {

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

extension GenderViewModel {

    func requestRegister(completion: @escaping (Result<Int, Error>) -> Void ) {
        let userInfo = UserRegisterInfo(
            phoneNumber: "+821088407593",
            FCMtoken: UserDefaults.standard.string(forKey: "FCMToken")!,
            nick: "youngmin",
            birth: "1994-11-14T09:23:44.054Z",
            email: "youngminah@gmail.com",
            gender: 1
        )
        let parameters = userInfo.toDictionary

        provider.request(.register(parameters: parameters)) { result in
            self.process(
                result: result,
                completion: completion
            )
        }
    }
}
