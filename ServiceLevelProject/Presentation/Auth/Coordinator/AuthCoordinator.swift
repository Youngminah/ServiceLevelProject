//
//  AuthCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/25.
//

import UIKit

final class AuthCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .auth

    private let userDefaults = UserDefaults.standard

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
//        if userDefaults.bool(forKey: UserDefaultKeyCase.isLoggedIn) {
//            showLoginViewController()
//        } else if userDefaults.bool(forKey: UserDefaultKeyCase.isNotFirstUser) {
//            connectTabBarCoordinator()
//        } else {
//            showOnboardingViewController()
//        }
        showOnboardingViewController()
    }

    func showOnboardingViewController() {
        let viewModel = OnBoardingViewModel(coordinator: self)
        let vc = OnBoardingViewController(viewModel: viewModel)
        navigationController.viewControllers = [vc]
    }

    func connectTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
    func showLoginViewController() {
        let loginUseCase = LoginUseCase(
            userRepository: UserRepository(),
            fireBaseRepository: FirbaseRepository()
        )
        let viewModel = LoginViewModel(coordinator: self, loginUseCase: loginUseCase)
        let vc = LoginViewController(viewModel: viewModel)
        navigationController.viewControllers = [vc]
    }

    func showCertifacationViewController(verifyID: String) {
        let certificationUseCase = CertificationUseCase(
            userRepository: UserRepository(),
            fireBaseRepository: FirbaseRepository(),
            sesacRepository: SesacRepository()
        )
        let viewModel = CertificationViewModel(
            verifyID: verifyID,
            coordinator: self,
            certificationUseCase: certificationUseCase
        )
        let vc = CertificationViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }

    func showNicknameViewController() {
        let vc = NicknameViewController(
            viewModel: NickNameViewModel(coordinator: self)
        )
        navigationController.viewControllers = [vc]
    }

    func showBirthViewController() {
        let vc = BirthViewController(
            viewModel: BirthViewModel(coordinator: self)
        )
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }

    func showEmailViewController() {
        let vc = EmailViewController(
            viewModel: EmailViewModel(coordinator: self)
        )
        navigationController.pushViewController(vc, animated: true)
    }

    func showGenderViewController() {
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
}
