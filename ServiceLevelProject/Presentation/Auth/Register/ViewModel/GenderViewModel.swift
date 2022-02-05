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

import Toast

final class GenderViewModel: ViewModelType {

    private weak var coordinator: AuthCoordinator?
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
        let indicatorAction: Driver<Bool>
    }
    var disposeBag = DisposeBag()

    private let isValid = BehaviorRelay<Bool>(value: false)
    private let showToastAction = PublishRelay<String>()
    private let isWomanSelected = BehaviorRelay<Bool>(value: false)
    private let isManSelected = BehaviorRelay<Bool>(value: false)
    private let indicatorAction = BehaviorRelay<Bool>(value: false)

    private var gender: GenderCase = .total

    init(coordinator: AuthCoordinator?, genderUseCase: GenderUseCase) {
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
                self.indicatorAction.accept(true)
                self.requestRegister(gender: self.gender)
            })
            .disposed(by: disposeBag)

        isManSelected
            .subscribe(onNext: { [weak self] isSelected in
                if isSelected {
                    self?.gender = .man
                    self?.isWomanSelected.accept(false)
                }
            })
            .disposed(by: disposeBag)

        isWomanSelected
            .subscribe(onNext: { [weak self] isSelected in
                if isSelected {
                    self?.gender = .woman
                    self?.isManSelected.accept(false)
                }
            })
            .disposed(by: disposeBag)

        Observable
            .combineLatest(isManSelected, isWomanSelected) { $0 || $1 }
            .subscribe(onNext: { [weak self] isValid in
                self?.gender = .total
                self?.isValid.accept(isValid)
            })
            .disposed(by: disposeBag)

        genderUseCase.successRegisterSignal
            .asSignal(onErrorJustReturn: ())
            .emit(onNext: { [weak self] in
                self?.indicatorAction.accept(false)
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        genderUseCase.failRegisterSignal
            .asSignal(onErrorJustReturn: .unknown)
            .emit(onNext: { [weak self] error in
                guard let self = self else { return }
                self.indicatorAction.accept(false)
                if error.rawValue == 201 {
                    self.coordinator?.showLoginViewController(toastMessage: "이미 가입한 유저입니다\n 다시 로그인해주세요.")
                } else if error.rawValue == 202 {
                    self.coordinator?.popRootToViewController(toastMessage: "사용할 수 없는 닉네임입니다.")
                } else if error.rawValue == 401 {
                    self.coordinator?.showLoginViewController(toastMessage: "로그인이 만료되었습니다.\n다시 로그인해주세요.")
                } else {
                    //print(error.description)
                    self.showToastAction.accept(error.description)
                }
            })
            .disposed(by: disposeBag)

        return Output(
            isValid: isValid.asDriver(),
            showToastAction: showToastAction.asSignal(),
            isWomanSelected: isWomanSelected.asDriver(),
            isManSelected: isManSelected.asDriver(),
            indicatorAction: indicatorAction.asDriver()
        )
    }
}

extension GenderViewModel {

    private func requestRegister(gender: GenderCase) {
        self.genderUseCase.requestRegister(gender: gender)
    }
}
