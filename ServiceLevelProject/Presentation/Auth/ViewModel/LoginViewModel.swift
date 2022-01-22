//
//  LoginViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/21.
//

import Foundation
import RxCocoa
import RxSwift

final class LoginViewModel: ViewModelType {

    struct Input {
        let didLimitTextChange: Driver<String>
        let didTextFieldBegin: Signal<Void>
        let didTextFieldEnd: Signal<Void>
    }
    struct Output {
        let phoneNumberText: Signal<String>
        let isValidState: Driver<Bool>
        let phoneNumberRemoveHiponAction: Signal<Void>
        let phoneNumberAddHiponAction: Signal<Void>
    }

    private let phoneNumberText = PublishRelay<String>()
    private let isValidState = BehaviorRelay<Bool>(value: false)
    private let phoneNumberRemoveHiponAction = PublishRelay<Void>()
    private let phoneNumberAddHiponAction = PublishRelay<Void>()

    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        input.didLimitTextChange
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                self.phoneNumberText.accept(text)
                self.isValidState.accept(text.isValidPhoneNumber())
            })
            .disposed(by: disposeBag)

        input.didTextFieldBegin
            .emit(onNext:{ [weak self] text in
                guard let self = self else { return }
                self.phoneNumberRemoveHiponAction.accept(())
            })
            .disposed(by: disposeBag)

        input.didTextFieldEnd
            .emit { [weak self] text in
                guard let self = self else { return }
                self.phoneNumberAddHiponAction.accept(())
            }
            .disposed(by: disposeBag)

        return Output(
            phoneNumberText: phoneNumberText.asSignal(),
            isValidState: isValidState.asDriver(),
            phoneNumberRemoveHiponAction: phoneNumberRemoveHiponAction.asSignal(),
            phoneNumberAddHiponAction: phoneNumberAddHiponAction.asSignal()
        )
    }
}
