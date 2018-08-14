//
//  InCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/13/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore
import TrustKeystore
import UIKit
import RealmSwift
import URLNavigator
import TrustWalletSDK
import Result
import UIKit

protocol InCoordinator_Delegate: class {
    func didCancel(in coordinator: InCoordinator)
    func didUpdateAccounts(in coordinator: InCoordinator)
}

class InCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: NavigationController
    
    
    let initialWallet: WalletInfo
    var keystore: Keystore
    let config: Config
    let navigator: Navigator
    weak var delegate: InCoordinator_Delegate?
    private var pendingTransactionsObserver: NotificationToken?
    init( keystore: Keystore, navigationController: NavigationController = NavigationController(isHiddenNavigationBar: true), wallet: WalletInfo, config: Config = .current, navigator: Navigator = Navigator()){
        self.navigationController = navigationController
        self.initialWallet = wallet
        self.keystore = keystore
        self.config = config
        self.navigator = navigator
    }
    func start() {
        
    }
    
    
}

