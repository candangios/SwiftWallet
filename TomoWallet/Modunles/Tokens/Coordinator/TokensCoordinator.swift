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
    func didPressAddToken(in viewController: UIViewController) {
        let viewModel = NewTokenViewModel(token: .none, session: self.session, tokensNetwork: self.network)
        let controller = NewTokenViewController(viewModel: viewModel)
        controller.delegate = self
        return controller
    }
    
    func didSelect(token: TokenObject, in viewController: UIViewController) {
        let tokenViewModel = TokenViewModel(token: token, store: store, transactionsStore: transactionsStore, tokensNetwork: network, session: session)
        let tokenVC = TokenVC(viewModel: tokenViewModel)
        tokenVC.delegate = self
        self.navigationController.pushViewController(tokenVC, animated: true)
    }
    
}
extension TokensCoordinator: TokenVC_Delegate{
    func didPressRequest(for token: TokenObject, in controller: UIViewController) {
        let first = self.session.account.accounts.filter{$0.coin == token.coin}.first
        guard let account = first else {
            return
        }
        let coinTypeViewModel = CoinTypeViewModel(type: .coin(account, token))
        let viewModel = ReveiceVideModel(coinTypeViewModel: coinTypeViewModel)
        let reveiceVC = ReveiceVC(viewModel: viewModel)
   
        
        reveiceVC.view.frame = navigationController.view.bounds
        reveiceVC.beginAppearanceTransition(true, animated: true)
        self.navigationController.view.addSubview(reveiceVC.view)
        self.navigationController.addChildViewController(reveiceVC)
        reveiceVC.view.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            reveiceVC.view.alpha = 1.0
        }, completion: { _ in
            reveiceVC.endAppearanceTransition()
            reveiceVC.didMove(toParentViewController: self.navigationController.visibleViewController)
        })
    }
    
    func didPressSend(for token: TokenObject, in controller: UIViewController) {
        self.delegate?.didPressSend(for: token, in: self)
        
    }
    
    func didPressInfo(for token: TokenObject, in controller: UIViewController) {
        
    }
    
    func didPress(viewModel: TokenViewModel, transaction: Transaction, in controller: UIViewController) {
        
    }
}
