//
//  TabBarCoordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import UIKit

final class TabBarCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var type: CoordinatorStyleCase = .tab

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }

    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map({
            self.createTabNavigationController(of: $0)
        })
        self.configureTabBarController(with: controllers)
    }

    func currentPage() -> TabBarPage? {
        TabBarPage(index: self.tabBarController.selectedIndex)
    }

    func selectPage(_ page: TabBarPage) {
        self.tabBarController.selectedIndex = page.pageOrderNumber
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        self.tabBarController.selectedIndex = page.pageOrderNumber
    }

    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber
        self.tabBarController.view.backgroundColor = .systemBackground
        self.tabBarController.tabBar.backgroundColor = .systemBackground
        self.tabBarController.tabBar.tintColor = .green
        self.tabBarController.tabBar.unselectedItemTintColor = .gray6
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }

    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        return UITabBarItem(
            title: page.pageTitle,
            image: UIImage(named: page.tabIconName()),
            tag: page.pageOrderNumber
        )
    }

    private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
        connectTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }

    private func connectTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(tabNavigationController)
            self.childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .sesacshop:
            let sesacShopCoordinator = SesacShopCoordinator(tabNavigationController)
            self.childCoordinators.append(sesacShopCoordinator)
            sesacShopCoordinator.start()
        case .sesacfriend:
            let sesacFriendCoordinator = SesacFriendCoordinator(tabNavigationController)
            self.childCoordinators.append(sesacFriendCoordinator)
            sesacFriendCoordinator.start()
        case .mypage:
            let myPageCoordinator = MyPageCoordinator(tabNavigationController)
            self.childCoordinators.append(myPageCoordinator)
            myPageCoordinator.start()
        }
    }
}
