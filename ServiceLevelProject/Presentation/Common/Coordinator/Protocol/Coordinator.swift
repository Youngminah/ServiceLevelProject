//
//  Coordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import UIKit

protocol Coordinator: AnyObject {

    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorStyleCase { get }

    func start()
    func finish()

    init(_ navigationController: UINavigationController)
}

extension Coordinator {

    func finish() { childCoordinators.removeAll() }

    func findCoordinator(type: CoordinatorStyleCase) -> Coordinator? {
        var stack: [Coordinator] = [self]

        while !stack.isEmpty {
            let currentCoordinator = stack.removeLast()
            if currentCoordinator.type == type {
                return currentCoordinator
            }
            currentCoordinator.childCoordinators.forEach({ child in
                stack.append(child)
            })
        }
        return nil
    }

    func changeAnimation() {
        if let window = UIApplication.shared.windows.first {
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil)
        }
    }
}
