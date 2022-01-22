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
    var type: CoordinatorStyle = .certification

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {}

    func showCertifacationViewController(verifyID: String) {
        let viewModel = CertificationViewModel(verifyID: verifyID, coordinator: self)
        let vc = CertificationViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
