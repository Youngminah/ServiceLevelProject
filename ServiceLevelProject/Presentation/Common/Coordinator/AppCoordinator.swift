//
//  AppCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

final class AppCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .app

    private let userDefaults = UserDefaults.standard

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
//        if userDefaults.bool(forKey: UserDefaultKeyCase.isLoggedIn) {
//            connectTabBarCoordinator()
//        } else {
//            connectAuthCoordinator()
//        }
        connectAuthCoordinator()
    }

    private func connectAuthCoordinator() {
        let authCoordinator = AuthCoordinator(self.navigationController)
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }

    private func connectTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
}
