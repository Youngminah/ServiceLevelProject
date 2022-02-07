//
//  HomeCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import UIKit

final class HomeCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .home

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
        let vc = HomeViewController(
            viewModel: HomeViewModel(
                coordinator: self,
                homeUseCase: HomeUseCase(
                    userRepository: UserRepository(),
                    fireBaseRepository: FirbaseRepository(),
                    sesacRepository: SesacRepository()
                )
            )
        )
        navigationController.pushViewController(vc, animated: true)
    }
}
