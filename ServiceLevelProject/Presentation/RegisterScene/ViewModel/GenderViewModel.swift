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

final class GenderViewModel: ViewModelType {

    private weak var coordinator: GenderCoordinator?
    private let genderUseCase: GenderUseCase

    struct Input {
        let didManButtonTap: Signal<Void>
        let didWomanButtonTap: Signal<Void>
        let didNextButtonTap: Signal<Void>
    }
    struct Output {
        let isValid: Driver<Bool>
        let showToastAction: Signal<String>
        let isWomanSelected: Driver<Bool>
        let isManSelected: Driver<Bool>
    }
    var disposeBag = DisposeBag()

    private let isValid = BehaviorRelay<Bool>(value: false)
    private let showToastAction = PublishRelay<String>()
    private let isWomanSelected = BehaviorRelay<Bool>(value: false)
    private let isManSelected = BehaviorRelay<Bool>(value: false)

    private var gender = -1

    init(coordinator: GenderCoordinator?, genderUseCase: GenderUseCase) {
        self.coordinator = coordinator
        self.genderUseCase = genderUseCase
    }

    func transform(input: Input) -> Output {

        input.didManButtonTap
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.isManSelected.accept(!self.isManSelected.value)
            })
            .disposed(by: disposeBag)

        input.didWomanButtonTap
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.isWomanSelected.accept(!self.isWomanSelected.value)
            })
            .disposed(by: disposeBag)

        input.didNextButtonTap
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.requestRegister(gender: self.gender)
            })
            .disposed(by: disposeBag)

        isManSelected
            .subscribe(onNext: { [weak self] isSelected in
                if isSelected {
                    self?.gender = 1
                    self?.isWomanSelected.accept(false)
                }
            })
            .disposed(by: disposeBag)

        isWomanSelected
            .subscribe(onNext: { [weak self] isSelected in
                if isSelected {
                    self?.gender = 0
                    self?.isManSelected.accept(false)
                }
            })
            .disposed(by: disposeBag)

        Observable
            .combineLatest(isManSelected, isWomanSelected) { $0 || $1 }
            .subscribe(onNext: { [weak self] isValid in
                self?.gender = -1
                self?.isValid.accept(isValid)
            })
            .disposed(by: disposeBag)

        genderUseCase.successRegisterSignal
            .asSignal(onErrorJustReturn: ())
            .emit(onNext: { [weak self] in
                self?.coordinator?.connectTabBarCoordinator()
            })
            .disposed(by: disposeBag)

        genderUseCase.failRegisterSignal
            .asSignal(onErrorJustReturn: .unknown)
            .emit(onNext: { [weak self] error in
                guard let self = self else { return }
                if error.rawValue == 202 {
                    self.coordinator?.connectNickNameCoordinator()
                } else if error.rawValue == 401 {
                    print("파이어베이스 ID 토큰 만료 재요청")
                } else {
                    self.showToastAction.accept(error.description)
                }
            })
            .disposed(by: disposeBag)

        return Output(
            isValid: isValid.asDriver(),
            showToastAction: showToastAction.asSignal(),
            isWomanSelected: isWomanSelected.asDriver(),
            isManSelected: isManSelected.asDriver()
        )
    }
}

extension GenderViewModel {

    private func requestRegister(gender: Int) {
        self.genderUseCase.requestRegister(gender: gender)
    }
}
