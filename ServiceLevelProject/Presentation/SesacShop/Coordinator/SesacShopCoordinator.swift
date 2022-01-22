//
//  SesacShopCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import UIKit

final class SesacShopCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .sesacShop

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SesacShopViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
