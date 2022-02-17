//
//  ChatViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/15.
//

import Foundation
import RxCocoa
import RxSwift

final class ChatViewModel: ViewModelType {

    private weak var coordinator: HomeCoordinator?
    private let useCase: ChatUseCase

    struct Input {
        let viewDidLoad: Observable<Void>
        let viewDidDisappear: Signal<Void>
        let backBarButtonTap: Signal<Void>
        let detailBarButtonTap: Signal<Void>
        let sendChat: Signal<String>
    }
    struct Output {
        let showToastAction: Signal<String>
        let myState: Signal<MyQueueState>
        let chatList: Driver<[Chat]>
    }
    var disposeBag = DisposeBag()

    private let chatList = BehaviorRelay<[Chat]>(value: [])
    private let showToastAction = PublishRelay<String>()
    private let myState = PublishRelay<MyQueueState>()

    init(coordinator: HomeCoordinator?, useCase: ChatUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.useCase.socketChatInfo()
                self?.useCase.requestMyQueueState()
                self?.chatList.accept([
                    Chat(_id: "me", __v: 0, text: "안녕하세요 :)", createdAt: "2022-01-16T06:55:54.784Z".toDate, from: "NuK12cdVaDVcc9e4ctxsLMNCrHQ2", to: "me"),
                    Chat(_id: "me", __v: 0, text: "안녕하세요!! 자전거 타러가시나여 이번주에 시간되시나여?", createdAt: "2022-01-16T06:55:54.784Z".toDate, from: "NuK12cdVaDVcc9e4ctxsLMNCrHQ2", to: "me"),
                    Chat(_id: "me", __v: 0, text: "안녕하세요!!", createdAt: "2022-01-16T06:55:55.784Z".toDate, from: "me", to: "NuK12cdVaDVcc9e4ctxsLMNCrHQ2"),
                    Chat(_id: "me", __v: 0, text: "포근포근 달콤해\n둥글둥글 부푸는 마음\n맛있는꿈을 그려봐요\n행복한 꿈빛 파티시엘~~~~~", createdAt: "2022-01-16T06:55:58.784Z".toDate, from: "me", to: "NuK12cdVaDVcc9e4ctxsLMNCrHQ2")
                ])
            })
            .disposed(by: disposeBag)

        input.sendChat
            .emit(onNext: { [weak self] text in
                self?.useCase.requestSendChat(chatQuery: ChatQuery(text: text))
            })
            .disposed(by: disposeBag)

        input.viewDidDisappear
            .emit(onNext: { [weak self] in
                self?.useCase.disconnectSocket()
            })
            .disposed(by: disposeBag)

        input.backBarButtonTap
            .emit(onNext: { [weak self] in
                self?.coordinator?.popToRootViewController()
            })
            .disposed(by: disposeBag)

        input.detailBarButtonTap
            .emit(onNext: {
                print("디테일버튼 클릭")
            })
            .disposed(by: disposeBag)

        self.useCase.successRequestMyQueueState
            .asSignal()
            .emit(onNext: { [weak self] state in
                self?.myState.accept(state)
            })
            .disposed(by: disposeBag)

        self.useCase.sendChat
            .asSignal()
            .emit(onNext: { [weak self] chat in
                guard let self = self else { return }
                var list = self.chatList.value
                list.append(chat)
                //print(chat)
                self.chatList.accept(list)
            })
            .disposed(by: disposeBag)

        self.useCase.receivedChat
            .asSignal()
            .emit(onNext: { [weak self] chat in
                guard let self = self else { return }
                var list = self.chatList.value
                list.append(chat)
                self.chatList.accept(list)
            })
            .disposed(by: disposeBag)

        return Output(
            showToastAction: showToastAction.asSignal(),
            myState: myState.asSignal(),
            chatList: chatList.asDriver()
        )
    }
}
