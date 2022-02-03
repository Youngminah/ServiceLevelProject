//
//  MyPageEditViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/29.
//

import Foundation
import Moya
import RxCocoa
import RxSwift
import Toast

final class MyPageEditViewModel: ViewModelType {

    private weak var coordinator: MyPageCoordinator?
    private let myPageEditUseCase: MyPageEditUseCase

    struct Input {
        let didWithdrawButtonTap: Signal<Void>
        let requestWithdrawSignal: Signal<Void>
        let requestUpdateSignal: Signal<UpdateUserInfo>
    }
    struct Output {
        let showAlertAction: Signal<Void>
        let showToastAction: Signal<String>
        let indicatorAction: Driver<Bool>
    }
    var disposeBag = DisposeBag()

    private let showAlertAction = PublishRelay<Void>()
    private let showToastAction = PublishRelay<String>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)

    init(coordinator: MyPageCoordinator?, myPageEditUseCase: MyPageEditUseCase) {
        self.coordinator = coordinator
        self.myPageEditUseCase = myPageEditUseCase
    }

    func transform(input: Input) -> Output {

        input.didWithdrawButtonTap
            .emit(onNext: { [weak self] in
                self?.showAlertAction.accept(())
            })
            .disposed(by: disposeBag)

        input.requestWithdrawSignal
            .emit(onNext: { [weak self] in
                self?.indicatorAction.accept(true)
                self?.requestWithdraw()
            })
            .disposed(by: disposeBag)

        input.requestUpdateSignal
            .emit(onNext: { [weak self] info in
                if let text = info.4 , text == "" {
                    self?.showToastAction.accept(ToastCase.emptyHobbyText.errorDescription)
                } else {
                    self?.indicatorAction.accept(true)
                    self?.requestUpdate(updateUserInfo: info)
                }
            })
            .disposed(by: disposeBag)

        myPageEditUseCase.successWithdrawSignal
            .asSignal()
            .emit(onNext: { [weak self] in
                self?.indicatorAction.accept(false)
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        myPageEditUseCase.successUpdateSignal
            .asSignal()
            .emit(onNext: { [weak self] in
                self?.indicatorAction.accept(false)
                self?.coordinator?.popMyPageEditViewController(message: "저장되었습니다.")
            })
            .disposed(by: disposeBag)

        myPageEditUseCase.failLogoutSignal
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.indicatorAction.accept(false)
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        return Output(
            showAlertAction: showAlertAction.asSignal(),
            showToastAction: showToastAction.asSignal(),
            indicatorAction: indicatorAction.asDriver()
        )
    }
}

extension MyPageEditViewModel {

    private func requestWithdraw() {
        self.myPageEditUseCase.requestWithdraw()
    }

    private func requestUpdate(updateUserInfo: UpdateUserInfo) {
        self.myPageEditUseCase.requestUpdateUserInfo(updateUserInfo: updateUserInfo)
    }
}
