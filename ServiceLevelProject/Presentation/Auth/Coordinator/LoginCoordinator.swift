//
//  LoginCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

final class LoginCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyle = .login

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = LoginViewModel(coordinator: self)
        let vc = LoginViewController(viewModel: viewModel)
        navigationController.viewControllers = [vc]
    }

    func showCertifacationScene(verifyID: String) {
        let certificationCoordinator = CertificationCoordinator(self.navigationController)
        childCoordinators.append(certificationCoordinator)
        certificationCoordinator.showCertifacationViewController(verifyID: verifyID)
    }
}
