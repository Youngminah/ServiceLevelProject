//
//  CertificationViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/21.
//

import Foundation
import FirebaseAuth
import RxCocoa
import RxSwift

final class CertificationViewModel: ViewModelType {

    private weak var coordinator: AuthCoordinator?
    private let certificationUseCase: CertificationUseCase

    struct Input {
        let startButtonTapSignal: Signal<String>
        let retransferButtonTap: Signal<Void>
        let signInFirebaseSignal: Signal<String>
        let didLimitText: Driver<String>
        let didLimitTime: Signal<Void>
    }
    struct Output {
        let isValidState: Driver<Bool>
        let showToastAction: Signal<String>
        let disposeTimerAction: Signal<Void>
        let indicatorAction: Driver<Bool>
    }
    var disposeBag = DisposeBag()

    private let isValidState = BehaviorRelay<Bool>(value: false)
    private let showToastAction = PublishRelay<String>()
    private let disposeTimerAction = PublishRelay<Void>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)

    private var verifyID: String

    init(
        verifyID: String,
        coordinator: AuthCoordinator?,
        certificationUseCase: CertificationUseCase
    ) {
        self.verifyID = verifyID
        self.coordinator = coordinator
        self.certificationUseCase = certificationUseCase
    }

    func transform(input: Input) -> Output {

        input.startButtonTapSignal
            .emit(onNext: { [weak self] certificationNumber in
                guard let self = self else { return }
                if self.isValidState.value {
                    self.indicatorAction.accept(true)
                    self.requestSignIn(certificationNumber: certificationNumber)
                } else {
                    self.showToastAction.accept(AuthError.inValidCertificationNumberFormat.errorDescription)
                }
            })
            .disposed(by: disposeBag)

        input.retransferButtonTap
            .throttle(.seconds(1), latest: false)
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.indicatorAction.accept(true)
                self.retransferCertificationCode()
            })
            .disposed(by: disposeBag)

        input.didLimitText
            .map(validationCertificationCode)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] in
                self?.isValidState.accept($0)
            })
            .disposed(by: disposeBag)

        input.didLimitTime
            .emit(onNext: { [weak self] text in
                guard let self = self else { return }
                self.showToastAction.accept(AuthError.timeOut.errorDescription)
            })
            .disposed(by: disposeBag)

        input.signInFirebaseSignal
            .emit(onNext: { [weak self] certificationNumber in
                guard let self = self else { return }
                self.requestSignIn(certificationNumber: certificationNumber)
            })
            .disposed(by: disposeBag)

        self.certificationUseCase.retransmitSuccessSignal
            .asSignal(onErrorJustReturn: "")
            .emit(onNext: { [weak self] _ in
                self?.indicatorAction.accept(false)
            })
            .disposed(by: disposeBag)

        self.certificationUseCase.failFirebaseFlowSignal
            .subscribe(onNext: { [weak self] error in
                self?.indicatorAction.accept(false)
                self?.showToastAction.accept(error.description)
            })
            .disposed(by: disposeBag)

        self.certificationUseCase.successLogInSignal
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.indicatorAction.accept(false)
                self.disposeTimerAction.accept(())
                self.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        self.certificationUseCase.unRegisteredUserSignal
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.indicatorAction.accept(false)
                self.disposeTimerAction.accept(())
                self.coordinator?.showNicknameViewController()
            })
            .disposed(by: disposeBag)

        self.certificationUseCase.unKnownErrorSignal
            .subscribe(onNext: { [weak self]  in
                self?.indicatorAction.accept(false)
                self?.showToastAction.accept("서버 에러가 발생하였습니다.\n나중에 다시 시도해주세요.")
            })
            .disposed(by: disposeBag)

        return Output(
            isValidState: isValidState.asDriver(),
            showToastAction: showToastAction.asSignal(),
            disposeTimerAction: disposeTimerAction.asSignal(),
            indicatorAction: indicatorAction.asDriver()
        )
    }
}

extension CertificationViewModel {

    private func validationCertificationCode(text: String) -> Bool {
        return text.count == 6 && text.isValidCertificationNumber()
    }

    private func requestSignIn(certificationNumber: String) {
        self.certificationUseCase.requestSignIn(verifyID: verifyID, code: certificationNumber)
    }

    private func retransferCertificationCode() {
        self.certificationUseCase.retransferCertificationCode()
    }
}
