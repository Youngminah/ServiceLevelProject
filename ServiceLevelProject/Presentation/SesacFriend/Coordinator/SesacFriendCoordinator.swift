//
//  SesacFriendCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/23.
//

import UIKit

final class SesacFriendCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .sesacFriend

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SesacFriendViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
