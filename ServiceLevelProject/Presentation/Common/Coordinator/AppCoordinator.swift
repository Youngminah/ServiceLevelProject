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
        userDefaults.set(false, forKey: UserDefaultKeyCase.isNotFirstUser)
        userDefaults.set(false, forKey: UserDefaultKeyCase.isLoggedIn)
    }

    func start() {
//        if userDefaults.bool(forKey: UserDefaultKeyCase.isLoggedIn) {
//            connectTabBarCoordinator()
//        } else {
//            connectAuthCoordinator()
//        }
        connectAuthFlow()
    }

    private func connectAuthFlow() {
        let authCoordinator = AuthCoordinator(self.navigationController)
        authCoordinator.delegate = self
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }

    private func connectTabBarFlow() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.delegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
}

extension AppCoordinator: CoordinatorDelegate {

    func didFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })

        //self.navigationController.view.backgroundColor = .systemBackground
        self.navigationController.viewControllers.removeAll()

        switch childCoordinator.type {
        case .auth:
            self.connectTabBarFlow()
        case .tab:
            self.connectAuthFlow()
        default:
            break
        }
    }
}
