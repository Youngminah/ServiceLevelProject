//
//  MyPageCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import UIKit

final class MyPageCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .myPage

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = MyPageViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
