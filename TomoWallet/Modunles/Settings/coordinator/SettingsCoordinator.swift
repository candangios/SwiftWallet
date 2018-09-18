//
//  SettingsCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 9/17/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
protocol SettingsCoordinator_Delegate: class {
    func didCancel(in coordinator: SettingsCoordinator)
}

class SettingsCoordinator:NSObject, Coordinator {
    var navigationController: NavigationController
    var childCoordinators = [Coordinator]()
    let session: WalletSession
    weak var delegate: SettingsCoordinator_Delegate?
    var coordinators: [Coordinator] = []
    
    lazy var rootViewController: SettingsVC = {
        let controller = SettingsVC(
            session: session
        )
        controller.delegate = self
        return controller
    }()
    init(
        navigationController: NavigationController,
        session: WalletSession) {
        self.navigationController = navigationController
        self.session = session
    }
    func start() {
        self.navigationController.pushViewController(rootViewController, animated: true)
    }
    
    func setPasscodeCoordinator(completion: ((Bool) -> Void)? = .none) {
        let coordinator = CreatePasscodeCoordinator()
        coordinator.delegate = self
        coordinator.start()
//        coordinator.lockViewController.willFinishWithResult = { [weak self] result in
//            if result {
//                let type = AutoLock.immediate
//                self?.lock.setAutoLockType(type: type)
//                self?.updateAutoLockRow(with: type)
//            }
//            completion?(result)
//            self?.navigationController?.dismiss(animated: true, completion: nil)
//        }
        addCoordinator(coordinator)
        navigationController.present(coordinator.navigationController, animated: true, completion: nil)
    }
}
extension SettingsCoordinator: SettingsVC_Delegate{
    func didAction(action: SettingsAction, in viewController: SettingsVC) {
        switch action {
        case .passcode:
            self.setPasscodeCoordinator()
        }
    }
}
extension SettingsCoordinator: CreatePasscodeCoordinator_Delegate{
    func didCancel(in coordinator: CreatePasscodeCoordinator) {
        self.removeCoordinator(coordinator)
    }
    
    
}

