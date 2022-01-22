//
//  Coordinator.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import UIKit

protocol Coordinator: AnyObject {

    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorStyle { get }

    func start()
    func finish()

    init(_ navigationController: UINavigationController)
}

extension Coordinator {

    func finish() { childCoordinators.removeAll() }

    func findCoordinator(type: CoordinatorStyle) -> Coordinator? {
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
}
