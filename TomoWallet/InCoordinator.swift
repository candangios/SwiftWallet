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
        tokensCoordinator.delegate = self
        self.addCoordinator(tokensCoordinator)
    }
}
extension InCoordinator: TokensCoordinator_Delegate{
    func didPressSend(for token: TokenObject, in coordinator: TokensCoordinator) {
        let session = coordinator.session
        
        let transfer: Transfer = {
            let server = token.coin.server
            switch token.type {
            case .coin:
                return Transfer(server: server, type: .ether(token, destination: .none))
            case .ERC20:
                return Transfer(server: server, type: .token(token))
            }
        }()
        switch session.account.type {
        case .privateKey, .hd:
            let first = session.account.accounts.filter { $0.coin == token.coin }.first
            guard let account = first else { return }
//
            let coordinator = SendCoordinator(
                transfer: transfer,
                navigationController: self.navigationController,
                session: session,
                keystore: keystore,
                account: account
            )
            coordinator.start()
//            coordinator.delegate = self
            addCoordinator(coordinator)
//            nav.pushCoordinator(coordinator: coordinator, animated: true)
        case .address:
            break
//            self.navigationController.displayError(error: InCoordinator.onlyWatchAccount)
          
        }
      
    }
    
    func didPress(url: URL, in coordinator: TokensCoordinator) {
        self.removeCoordinator(coordinator)
    }
    
    
}

