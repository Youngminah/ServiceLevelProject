//
//  NickNameCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

final class NickNameCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .nickname

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = NicknameViewController(
            viewModel: NickNameViewModel(coordinator: self)
        )
        navigationController.viewControllers = [vc]
    }

    func connectBirthCoordinator() {
        let birthCoordinator = BirthCoordinator(self.navigationController)
        birthCoordinator.start()
        childCoordinators.append(birthCoordinator)
    }
}
