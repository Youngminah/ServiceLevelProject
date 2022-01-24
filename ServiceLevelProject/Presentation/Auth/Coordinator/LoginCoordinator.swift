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
    var type: CoordinatorStyleCase = .login

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginUseCase = LoginUseCase(
            userRepository: UserRepository(),
            fireBaseRepository: FirbaseRepository()
        )
        let viewModel = LoginViewModel(coordinator: self, loginUseCase: loginUseCase)
        let vc = LoginViewController(viewModel: viewModel)
        navigationController.viewControllers = [vc]
    }

    func connectCertifacationCoordinator(verifyID: String) {
        let certificationCoordinator = CertificationCoordinator(self.navigationController)
        childCoordinators.append(certificationCoordinator)
        certificationCoordinator.showCertifacationViewController(verifyID: verifyID)
    }
}
