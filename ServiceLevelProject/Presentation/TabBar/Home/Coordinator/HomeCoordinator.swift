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
//        UserDefaults.standard.set(MatchStatus.general.rawValue, forKey: UserDefaultKeyCase.matchStatus)
    }

    func start() {
        let vc = HomeViewController(
            viewModel: HomeViewModel(
                coordinator: self,
                homeUseCase: HomeUseCase(
                    userRepository: UserRepository(),
                    fireBaseRepository: FirebaseRepository(),
                    sesacRepository: SesacRepository()
                )
            )
        )
        navigationController.pushViewController(vc, animated: true)
    }

    func showHomeSearchViewController(coordinate: Coordinate) {
        let vc = HomeSearchViewController(
            viewModel: HomeSearchViewModel(
                coordinator: self,
                useCase: HomeSearchUseCase(
                    userRepository: UserRepository(),
                    fireBaseRepository: FirebaseRepository(),
                    sesacRepository: SesacRepository()
                ),
                coordinate: coordinate
            )
        )
        vc.hidesBottomBarWhenPushed = true
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }

    func showHobbySearchViewController(coordinate: Coordinate) {
        let vc = HobbySearchViewController(
            viewModel: HobbySearchViewModel(
                coordinator: self,
                useCase: HobbySearchUseCase(
                    userRepository: UserRepository(),
                    fireBaseRepository: FirebaseRepository(),
                    sesacRepository: SesacRepository()
                ),
                coordinate: coordinate
            )
        )
        vc.title = "새싹 찾기"
        vc.hidesBottomBarWhenPushed = true
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: true)
        IndicatorView.shared.show(backgoundColor: .white)
    }

    func showReviewDetailViewController(reviews: [String]) {
        let vc = ReviewDetailViewController(reviews: reviews)
        vc.title = "새싹 리뷰"
        navigationController.pushViewController(vc, animated: true)
    }

    func showChatViewController() {
        let vc = ChatViewController()
        navigationController.pushViewController(vc, animated: true)
    }

    func changeTabToMyPageViewController(message: String) {
        navigationController.tabBarController?.selectedIndex = 3
        navigationController.tabBarController?.view.makeToast(message, position: .top)
    }

    func popToRootViewController(message: String? = nil) {
        navigationController.popToRootViewController(animated: true)
        if let message = message {
            navigationController.view.makeToast(message, position: .top)
        }
    }
}
