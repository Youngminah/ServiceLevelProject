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
    var type: CoordinatorStyleCase = .app

    private let userDefaults = UserDefaults.standard

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
//        if userDefaults.bool(forKey: UserDefaultKeyCase.isFirstUser) {
//            showOnBoardingScene()
//        } else if userDefaults.bool(forKey: UserDefaultKeyCase.isLoggedIn) {
//            showLoginScene()
//        } else {
//            showTabBarScene()
//        }
//        showOnBoardingScene()
        connectLoginCoordinator()
//        showTabBarScene()
    }

    private func connectOnBoardingCoordinator() {
        let onBoardingCoordinator = OnBoardingCoordinator(self.navigationController)
        onBoardingCoordinator.start()
        childCoordinators.append(onBoardingCoordinator)
    }

    private func connectLoginCoordinator() {
        let loginCoordinator = LoginCoordinator(self.navigationController)
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }

    private func connectTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
}
