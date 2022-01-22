//
//  AppCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

final class AppCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyle = .app

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }

    func start() {
        if UserDefaults.standard.bool(forKey: UserDefaultKey.isFirstUser) {
            self.showOnBoardingScene()
        } else {
            self.showLoginScene()
        }
    }

    private func showOnBoardingScene() {
        let onBoardingCoordinator = OnBoardingCoordinator(self.navigationController)
        onBoardingCoordinator.start()
        childCoordinators.append(onBoardingCoordinator)
    }

    private func showLoginScene() {
        let loginCoordinator = LoginCoordinator(self.navigationController)
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }

    private func showTabBarScene() {

    }
}
