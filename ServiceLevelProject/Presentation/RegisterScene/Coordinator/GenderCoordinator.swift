//
//  GenderCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

final class GenderCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .gender

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = GenderViewController(
            viewModel: GenderViewModel(
                coordinator: self,
                genderUseCase: GenderUseCase(
                    userRepository: UserRepository(),
                    sesacRepository: SesacRepository()
                )
            )
        )
        navigationController.pushViewController(vc, animated: true)
    }

    func connectTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }

    func connectNickNameCoordinator() {
        let nickNameCoordinator = NickNameCoordinator(self.navigationController)
        nickNameCoordinator.start()
        childCoordinators.append(nickNameCoordinator)
    }
}

