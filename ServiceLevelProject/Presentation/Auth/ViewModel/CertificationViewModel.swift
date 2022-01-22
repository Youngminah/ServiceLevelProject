//
//  CertificationViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

final class CertificationViewModel: CommonViewModel, ViewModelType {

    struct Input {
        let requestRegisterSignal: Signal<Void>
        let didLimitText: Driver<String>
        let didLimitTime: Signal<Void>
    }
    struct Output {
        let isValidState: Driver<Bool>
        let showToastAction: Signal<String>
    }

    private let isValidState = BehaviorRelay<Bool>(value: false)
    private let showToastAction = PublishRelay<String>()

    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        input.didLimitText
            .map{ $0.count == 6 ? true : false }
            .distinctUntilChanged()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                $0 ? self.isValidState.accept(true) : self.isValidState.accept(false)
            })
            .disposed(by: disposeBag)

        input.didLimitTime
            .emit(onNext: { [weak self] text in
                guard let self = self else { return }
                self.showToastAction.accept("전화번호 인증 실패")
            })
            .disposed(by: disposeBag)

        input.requestRegisterSignal
            .emit(onNext: { [weak self] text in
                guard let self = self else { return }
                self.requestRegister { response in
                    switch response {
                    case .success(let code):
                        print("서버에서 준 코드!! \(code)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            })
            .disposed(by: disposeBag)

        return Output(
            isValidState: isValidState.asDriver(),
            showToastAction: showToastAction.asSignal()
        )
    }
}

extension CertificationViewModel {

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
            self.process(result: result, completion: completion)
        }
    }
}
