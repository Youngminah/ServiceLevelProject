//
//  OnBoardingCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

final class OnBoardingCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyle = .onBoarding

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = OnBoardingViewModel(coordinator: self)
        let vc = OnBoardingViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }

    func showLoginScene() {
        let loginCoordinator = LoginCoordinator(self.navigationController)
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
}
