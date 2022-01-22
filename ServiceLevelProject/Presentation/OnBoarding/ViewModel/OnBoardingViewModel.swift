//
//  OnBoardingViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit.UIImage

final class OnBoardingViewModel {
    
    private weak var coordinator: OnBoardingCoordinator?

    private let onBoardingImageViews: [UIImage] = [
        Asset.onBoarding1.image,
        Asset.onBoarding2.image,
        Asset.onBoarding3.image
    ]

    private let mutableAttributedStrings: [NSMutableAttributedString] = [
        NSMutableAttributedString()
            .greenHighlight(string: "위치 기반")
            .regular(string: "으로 빠르게\n주위 친구를 확인"),
        NSMutableAttributedString()
            .greenHighlight(string: "관심사가 같은 친구")
            .regular(string: "를\n찾을 수 있어요"),
        NSMutableAttributedString()
            .regular(string: "SeSAC Freinds")
    ]

    init(coordinator: OnBoardingCoordinator?) {
        self.coordinator = coordinator
    }

    var count: Int {
        return onBoardingImageViews.count
    }

    func onBoardingImageList(at index: Int) -> UIImage {
        return onBoardingImageViews[index]
    }

    func onBoardingTitleString(at index: Int) -> NSMutableAttributedString {
        return mutableAttributedStrings[index]
    }

    func showLoginController() {
        //UserDefaults.standard.set(true, forKey: UserDefaultKeyCase.isLoggedIn)
        coordinator?.showLoginScene()
    }
}
