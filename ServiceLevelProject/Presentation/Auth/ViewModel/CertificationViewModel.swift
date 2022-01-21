//
//  CertificationViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/21.
//

import Foundation
import RxCocoa
import RxSwift

final class CertificationViewModel: ViewModelType {

    struct Input {
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
            .distinctUntilChanged()
            .filter { text in
                text.count >= 6 ? true : false
            }
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                self.isValidState.accept(true)
            })
            .disposed(by: disposeBag)

        input.didLimitTime
            .emit (onNext: { [weak self] text in
                guard let self = self else { return }
                self.showToastAction.accept("전화번호 인증 실패")
            })
            .disposed(by: disposeBag)

        return Output(
            isValidState: isValidState.asDriver(),
            showToastAction: showToastAction.asSignal()
        )
    }
}
