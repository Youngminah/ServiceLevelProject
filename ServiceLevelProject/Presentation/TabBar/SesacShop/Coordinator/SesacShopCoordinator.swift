//
//  SesacShopCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import UIKit

final class SesacShopCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .sesacShop

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SesacShopViewController(
            viewModel: SesacShopViewModel(
                coordinator: self,
                useCase: SesacShopUseCase(
                    userRepository: UserRepository(),
                    fireBaseRepository: FirebaseRepository(),
                    sesacRepository: SesacRepository()
                )
            )
        )
        vc.title = "새싹샵"
        navigationController.pushViewController(vc, animated: true)
    }
}
