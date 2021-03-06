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
        let vc = MyPageViewController(coordinator: self)
        vc.title = "내정보"
        navigationController.pushViewController(vc, animated: true)
    }

    func showMyPageEditViewController() {
        let vc = MyPageEditViewController(
            viewModel: MyPageEditViewModel(
                coordinator: self,
                myPageEditUseCase: MyPageEditUseCase(
                    userRepository: UserRepository(),
                    fireBaseRepository: FirebaseRepository(),
                    sesacRepository: SesacRepository()
                )
            )
        )
        vc.title = "정보 관리"
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    func popMyPageEditViewController(message: String) {
        navigationController.popViewController(animated: true)
        navigationController.view.makeToast(message, position: .top)
    }
}
