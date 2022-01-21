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
    func start()
    func finish()

    init(_ navigationController: UINavigationController)
}
