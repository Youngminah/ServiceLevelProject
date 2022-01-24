//
//  CertificationViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/21.
//

import Foundation
import FirebaseAuth
import Moya
import RxCocoa
import RxSwift

final class CertificationViewModel: ViewModelType {

    private weak var coordinator: CertificationCoordinator?
    private let certificationUseCase: CertificationUseCase

    struct Input {
        let signInFirebaseSignal: Signal<String>
        let didLimitText: Driver<String>
        let didLimitTime: Signal<Void>
    }
    struct Output {
        let isValidState: Driver<Bool>
        let showToastAction: Signal<String>
        let disposeTimerAction: Signal<Void>
    }
    var disposeBag = DisposeBag()

    private let isValidState = BehaviorRelay<Bool>(value: false)
    private let showToastAction = PublishRelay<String>()
    private let disposeTimerAction = PublishRelay<Void>()

    private var verifyID: String

    init(
        verifyID: String,
        coordinator: CertificationCoordinator?,
        certificationUseCase: CertificationUseCase
    ) {
        self.verifyID = verifyID
        self.coordinator = coordinator
        self.certificationUseCase = certificationUseCase
    }

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

        input.signInFirebaseSignal
            .emit(onNext: { [weak self] certificationNumber in
                guard let self = self else { return }
                self.requestSignIn(certificationNumber: certificationNumber)
            })
            .disposed(by: disposeBag)

        self.certificationUseCase.failFirebaseFlowSignal
            .subscribe(onNext: { [weak self] error in
                self?.showToastAction.accept(error.description)
            })
            .disposed(by: disposeBag)

        self.certificationUseCase.successLogInSignal
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.disposeTimerAction.accept(())
                self.coordinator?.connectTabBarCoordinator()
            })
            .disposed(by: disposeBag)

        self.certificationUseCase.unRegisteredUserSignal
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.disposeTimerAction.accept(())
                self.coordinator?.connectNickNameCoordinator()
            })
            .disposed(by: disposeBag)

        self.certificationUseCase.unKnownErrorSignal
            .subscribe(onNext: { [weak self] in
                self?.showToastAction.accept("서버 에러가 발생하였습니다.\n나중에 다시 시도해주세요.")
            })
            .disposed(by: disposeBag)

        self.certificationUseCase.failFirebaseFlowSignal
            .subscribe(onNext: { [weak self] error in
                self?.showToastAction.accept(error.description)
            })
            .disposed(by: disposeBag)

        return Output(
            isValidState: isValidState.asDriver(),
            showToastAction: showToastAction.asSignal(),
            disposeTimerAction: disposeTimerAction.asSignal()
        )
    }
}

extension CertificationViewModel {

    private func requestSignIn(certificationNumber: String) {
        self.certificationUseCase.requestSignIn(verifyID: verifyID, code: certificationNumber)
    }
}
