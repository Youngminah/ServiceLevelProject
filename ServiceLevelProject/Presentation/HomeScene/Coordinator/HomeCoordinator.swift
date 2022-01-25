//
//  HomeCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import UIKit

final class HomeCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .home

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = HomeViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}