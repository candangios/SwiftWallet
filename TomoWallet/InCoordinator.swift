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

enum InCoordinatorError: LocalizedError {
    case onlyWatchAccount
    
    var errorDescription: String? {
        return NSLocalizedString(
            "InCoordinatorError.onlyWatchAccount",
            value: "This wallet can be only used for watching. Import Private Key/Keystore to sign transactions/messages",
            comment: ""
        )
    }
}

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
//    private var pendingTransactionsObserver: NotificationToken?
    
    var settingsCoordinator: SettingsCoordinator? {
        return self.childCoordinators.compactMap { $0 as? SettingsCoordinator }.first
    }
    
    var tokensCoordinator: TokensCoordinator? {
        return self.childCoordinators.compactMap { $0 as? TokensCoordinator }.first
    }
    var tokenVC: TokenVC? {
        return self.navigationController.viewControllers.compactMap { $0 as? TokenVC }.first
    }
    
    private func realm(for config: Realm.Configuration) -> Realm {
        return try! Realm(configuration: config)
    }
    
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
   
        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        
        let migration = MigrationInitializer(account: account)
        migration.perform()
        
        let realm =  self.realm(for: migration.config)
        let sharedRealm =  self.realm(for: sharedMigration.config)
        
        let session = WalletSession(
            account: account,
            realm: realm,
            sharedRealm: sharedRealm,
            config: config
        )
        
        let tokensCoordinator = TokensCoordinator(keystore: self.keystore, walletSesstion: session, navigationController: self.navigationController)
        tokensCoordinator.start()
        tokensCoordinator.delegate = self
        self.addCoordinator(tokensCoordinator)
    }
}
extension InCoordinator: TokensCoordinator_Delegate{
    func didPressSettings(coordinator: TokensCoordinator) {
        if let settingsCoordinator = self.settingsCoordinator{
            settingsCoordinator.start()
        }else{
            let settingsCoordinator = SettingsCoordinator(navigationController: self.navigationController, session: coordinator.session)
            settingsCoordinator.start()
            self.addCoordinator(settingsCoordinator)
        }
    }
    
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
            let coordinator = SendCoordinator(
                transfer: transfer,
                navigationController: self.navigationController,
                session: session,
                keystore: keystore,
                account: account
            )
            coordinator.start()
            
            coordinator.didFinish = {[weak self](result, coordinator) in
                guard let `self` = self else { return }
                print(self.navigationController.viewControllers.count)
                self.removeCoordinator(coordinator)
                switch result {
                case .success(let confirmResult):
                    switch confirmResult{
                    case .sentTransaction(let sentTransaction):
                        let transaction = SentTransaction.from(transaction: sentTransaction)
                        guard let tokensCoordinator = self.tokensCoordinator else {return}
                        tokensCoordinator.transactionsStore.add([transaction])
                        tokensCoordinator.showTransactionExecute(transaction: transaction, token: token, onDissmiss: {
                        if let tokenVC = self.tokenVC {
                                self.navigationController.popToViewController(tokenVC, animated: true)}
                        })
                     
                    case .signedTransaction:
                        break
                    }
                    
                case .failure(let error):
                    if let tokenVC = self.tokenVC {
                        self.navigationController.popToViewController(tokenVC, animated: true)
                    }
                    (self.navigationController as NavigationController).displayError(error: error)
                }
              
            }
            addCoordinator(coordinator)
        case .address:
               // online Account not transaction
            self.navigationController.displayError(error: InCoordinatorError.onlyWatchAccount)
         
            break

          
        }
      
    }
    
    func didPress(url: URL, in coordinator: TokensCoordinator) {
        self.removeCoordinator(coordinator)
    }
    
}


