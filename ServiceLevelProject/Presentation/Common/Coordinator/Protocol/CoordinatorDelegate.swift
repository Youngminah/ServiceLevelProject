//
//  CoordinatorDelegate.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/26.
//

import Foundation

protocol CoordinatorDelegate: AnyObject {

    func didFinish(childCoordinator: Coordinator)
}
