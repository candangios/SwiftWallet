//
//  WalletCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/13/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import UIKit


protocol InitialWalletCoordinator_Delegate: class {
    func didCancel(in coordinator: InitialWalletCoordinator)
    func didAddAccount(_ account: WalletInfo, in coordinator: InitialWalletCoordinator)
}

class InitialWalletCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: NavigationController
    
    weak var delegate: InitialWalletCoordinator_Delegate?
    
    let keystore: Keystore
    let entryPoint: WalletEntryPoint
    
    init(keystore: Keystore, navigationController: NavigationController = NavigationController(isHiddenNavigationBar: true), entryPoint: WalletEntryPoint ) {
        self.keystore = keystore
        self.navigationController = navigationController
        self.entryPoint = entryPoint
    }
    
    func start() {
        switch entryPoint {
        case .createInstantWallet:
            self.createInstanWallet()
        case .importWallet:
           self.importWallet()
        case .welcome:
            break
        }
    }
    func createInstanWallet() {
        let walletCoordinator = WalletCoordinator(keystore: self.keystore, navigationController: self.navigationController, entryPoint: entryPoint)
        walletCoordinator.delegate = self
        walletCoordinator.start()
        self.addCoordinator(walletCoordinator)
    }
    func importWallet(){
        let walletCoordinator = WalletCoordinator(keystore: self.keystore, navigationController: self.navigationController, entryPoint: entryPoint)
        walletCoordinator.delegate = self
        walletCoordinator.start()
        self.addCoordinator(walletCoordinator)
        
    }
    
}
extension InitialWalletCoordinator: WalletCoordinator_Delegate{
    func didCancel(in coordinator: WalletCoordinator, account: WalletInfo) {
        self.delegate?.didCancel(in: self)
        self.removeCoordinator(coordinator)
    }
    
    func didFinish(with account: WalletInfo, in coordinator: WalletCoordinator) {
        self.delegate?.didAddAccount(account, in: self)
        self.removeCoordinator(coordinator)
    }
    

    
    
}
