//
//  WalletCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/13/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import UIKit

class InitialWalletCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: NavigationController
    
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
            createInstanWallet()
        case .importWallet:
            break
        case .welcome:
            break
        }
    }
    func createInstanWallet() {
        
        let walletCoordinator = WalletCoordinator(keystore: self.keystore, navigationController: self.navigationController, entryPoint: entryPoint)
        walletCoordinator.start()
        self.childCoordinators.append(walletCoordinator)

    }
    
    
}
