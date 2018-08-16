//
//  AppCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/3/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import TrustCore
import URLNavigator

class MainCoordinator:NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: NavigationController
    
    private let keystore: Keystore
    private var navigator: URLNavigatorCoordinator
    
    lazy var welcomeScreen: WelcomeVC = {
        let controller = WelcomeVC()
        controller.delegate = self
        return controller
    }()
    
  
    init(window: UIWindow, keystore: Keystore,navigationController: NavigationController = NavigationController(isHiddenNavigationBar: true), navigator: URLNavigatorCoordinator = URLNavigatorCoordinator()) {
        self.keystore = keystore
        self.navigator = navigator
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        if keystore.hasWallets {
            let wallet = keystore.recentlyUsedWallet ?? keystore.wallets.first!
            showTransactions(for: wallet)
        } else {
            self.showWelcomScreen()
        }
    }
    
    
    // Navigate show view
    func showWelcomScreen() {
        self.navigationController.show(welcomeScreen, sender: self)
    }
    
    func showTransactions(for wallet: WalletInfo){
        let inCoordinator = InCoordinator(keystore: self.keystore, navigationController: self.navigationController, wallet: wallet, navigator: navigator.navigator)
        inCoordinator.start()
        self.addCoordinator(inCoordinator)
    }
    
    func showInitialWalletCoordinator (entryPoint: WalletEntryPoint){
        let initialWalletCoordinator = InitialWalletCoordinator(keystore: self.keystore, navigationController: self.navigationController, entryPoint: entryPoint)
        initialWalletCoordinator.start()
        self.addCoordinator(initialWalletCoordinator)
    }
}

extension MainCoordinator: WelcomeVC_Delegate{
    func didPressCreateWallet(in viewController: WelcomeVC) {
        showInitialWalletCoordinator(entryPoint: .createInstantWallet)
    }
    func didPressImportWallet(in viewController: WelcomeVC) {
      
    }
}

extension MainCoordinator: WalletCoordinator_Delegate{
    func didFinish(with account: WalletInfo, in coordinator: WalletCoordinator) {
        self.removeCoordinator(coordinator)
        
    }
    
    func didCancel(in coordinator: WalletCoordinator) {
        self.removeCoordinator(coordinator)
    }
    
    
}
