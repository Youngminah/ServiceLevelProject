//
//  CertificationCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

final class CertificationCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .certification

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {}

    func showCertifacationViewController(verifyID: String) {
        let certificationUseCase = CertificationUseCase(
            userRepository: UserRepository(),
            fireBaseRepository: FirbaseRepository(),
            sesacRepository: SesacRepository()
        )
        let viewModel = CertificationViewModel(
            verifyID: verifyID,
            coordinator: self,
            certificationUseCase: certificationUseCase
        )
        let vc = CertificationViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }

    func connectNickNameCoordinator() {
        let nickNameCoordinator = NickNameCoordinator(self.navigationController)
        nickNameCoordinator.start()
        childCoordinators.append(nickNameCoordinator)
    }

    func connectTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
}
