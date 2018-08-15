//
//  TokensCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/14/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import UIKit

class TokensCoordinator:NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: NavigationController
    
    let session: WalletSession
    let keystore: Keystore
    let store: TokensDataStore
    let transactionsStore: TransactionsStorage
    
    lazy var network: NetworkProtocol = {
        return ApiNetwork(provider: ApiProviderFactory.makeProvider(), wallet: session.account)
    }()

    
    lazy var tokensViewController: TokensVC = {
        let viewModel = TokensViewModel(session: session, store: store, tokensNetwork: network, transactionStore: transactionsStore)
        let controller = TokensVC(viewModel: viewModel)
        controller.delegate = self
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
        self.navigationController.pushViewController(tokensViewController, animated: true)
    }
}

extension TokensCoordinator: TokensVC_Delegate{
    
    func didPressAddToken(in viewController: UIViewController) {
        print("hehe")
    }
    
    
}
