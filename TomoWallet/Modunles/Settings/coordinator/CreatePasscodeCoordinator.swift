//
//  CreatePasscodeCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 9/18/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
enum PasscodeType{
    case create
    case edit
}
protocol CreatePasscodeCoordinator_Delegate: class {
    func didCancel(in coordinator: CreatePasscodeCoordinator)
}

final class CreatePasscodeCoordinator: Coordinator{
    var childCoordinators = [Coordinator]()
    var lock: Lock
    var navigationController: NavigationController
    weak var delegate: CreatePasscodeCoordinator_Delegate?
    var willFinishWithResult: ((_ success: Bool) -> Void)?
    init(navigationController: NavigationController = NavigationController(isHiddenNavigationBar: false), lock: Lock) {
        self.lock = lock
        self.navigationController = navigationController
    }
    func start() {
        let viewModel = CreatePasscodeViewModel(lock: self.lock)
        let createPasscodeVC = CreatePasscodeVC( viewModel, type: lock.isPasscodeSet() == true ? CreatePasscodeType.edit : CreatePasscodeType.initial)
        createPasscodeVC.delegate = self
        createPasscodeVC.willFinishWithResult = willFinishWithResult
        self.navigationController.viewControllers = [createPasscodeVC]
    }
    
}
extension CreatePasscodeCoordinator: CreatePasscodeVC_Delegate{
    func didCloseAction() {
        self.navigationController.dismiss(animated: true) {
            self.delegate?.didCancel(in: self)
        }
    }
}
