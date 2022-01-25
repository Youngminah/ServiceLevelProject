//
//  BirthCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

final class BirthCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .birth

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = BirthViewController(
            viewModel: BirthViewModel(coordinator: self)
        )
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }

    func connectEmailCoordinator() {
        let emailCoordinator = EmailCoordinator(self.navigationController)
        emailCoordinator.start()
        childCoordinators.append(emailCoordinator)
    }
}
