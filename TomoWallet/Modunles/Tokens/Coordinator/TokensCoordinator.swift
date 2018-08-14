//
//  TokensCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/14/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation

class TokensCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: NavigationController
    
    let session: WalletSession
    let keystore: Keystore
    let store: TokensDataStore
    let transactionsStore: TransactionsStorage
    
    lazy var tokensViewController: WalletVC = {
   
        let controller = WalletVC()
//        controller.delegate = self
        return controller
    }()
    
    init(keystore: Keystore, walletSesstion: WalletSession, navigationController: NavigationController = NavigationController(isHiddenNavigationBar: true)) {
        self.session = walletSesstion
        self.keystore = keystore
        self.store = session.tokensStorage
        self.transactionsStore = session.transactionsStorage
        self.navigationController = navigationController
        
    }
    
    func start() {
        self.navigationController.show(tokensViewController, sender: self)
    }
    
    
}
