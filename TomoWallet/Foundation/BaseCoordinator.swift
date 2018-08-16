//
//  Coordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/9/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//
import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: NavigationController { get set }
    
    func start()
}
extension Coordinator {
    func addCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func removeAllCoordinators() {
        childCoordinators.removeAll()
    }
}
