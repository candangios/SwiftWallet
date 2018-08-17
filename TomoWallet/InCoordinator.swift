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
        showMainController(account: self.initialWallet)
        
    }
    func showMainController(account: WalletInfo){
        
        let migration = MigrationInitializer(account: account)
   
        let sharedMigration = SharedMigrationInitializer()
        let realm = try? Realm(configuration: migration.config)
        let sharedRealm = try? Realm(configuration: sharedMigration.config)
        
        let session = WalletSession(
            account: account,
            realm: realm!,
            sharedRealm: sharedRealm!,
            config: config
        )
        
        let tokensCoordinator = TokensCoordinator(keystore: self.keystore, walletSesstion: session, navigationController: self.navigationController)
        tokensCoordinator.start()
        self.childCoordinators.append(tokensCoordinator)
    }
    
    
}

