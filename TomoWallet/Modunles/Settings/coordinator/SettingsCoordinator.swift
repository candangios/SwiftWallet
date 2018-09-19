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
    let lock = Lock()
    weak var delegate: SettingsCoordinator_Delegate?
    var coordinators: [Coordinator] = []
    
    lazy var rootViewController: SettingsVC = {
        let controller = SettingsVC(
            session: session,
            lock: lock
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
        let coordinator = CreatePasscodeCoordinator(lock: self.lock)
        coordinator.willFinishWithResult = { [weak self] result in
            if result {
                self?.rootViewController.reload()
//                let type = AutoLock.immediate
//                self?.lock.setAutoLockType(type: type)
//                self?.updateAutoLockRow(with: type)
            }
            completion?(result)
            self?.navigationController.dismiss(animated: true, completion: nil)
            self?.removeCoordinator(coordinator)
        }
        coordinator.delegate = self
        coordinator.start()
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

