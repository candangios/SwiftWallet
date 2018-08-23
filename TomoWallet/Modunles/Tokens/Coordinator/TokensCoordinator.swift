//
//  TokensCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/14/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import UIKit
protocol TokensCoordinator_Delegate: class {
    func didPressSend(for token: TokenObject, in coordinator: TokensCoordinator)
    func didPress(url: URL, in coordinator: TokensCoordinator)
}

class TokensCoordinator:NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: NavigationController
    let session: WalletSession
    let keystore: Keystore
    let store: TokensDataStore
    let transactionsStore: TransactionsStorage
    
    weak var delegate: TokensCoordinator_Delegate?
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
    func didSelect(token: TokenObject, in viewController: UIViewController) {
        let tokenViewModel = TokenViewModel(token: token, store: store, transactionsStore: transactionsStore, tokensNetwork: network, session: session)
        let tokenVC = TokenVC(viewModel: tokenViewModel)
        tokenVC.delegate = self
        self.navigationController.pushViewController(tokenVC, animated: true)
    }
    
    func didRequest(token: TokenObject, in viewController: UIViewController) {
        
    }
    
    func didPressAddToggleEnableToken(in viewController: UIViewController) {
       // viewController togger token account
    }
}
extension TokensCoordinator: TokenVC_Delegate{
    func didPressRequest(for token: TokenObject, in controller: UIViewController) {
        
    }
    
    func didPressSend(for token: TokenObject, in controller: UIViewController) {
        self.delegate?.didPressSend(for: token, in: self)
        
    }
    
    func didPressInfo(for token: TokenObject, in controller: UIViewController) {
        
    }
    
    func didPress(viewModel: TokenViewModel, transaction: Transaction, in controller: UIViewController) {
        
    }
}
