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

class ContainerCoordinator: UIViewController, BaseCoordinator {
    private let keystore: Keystore
    private var navigator: URLNavigatorCoordinator
    private var window: UIWindow!
    
  
    init(window: UIWindow, keystore: Keystore, navigator: URLNavigatorCoordinator = URLNavigatorCoordinator()) {
        self.keystore = keystore
        self.navigator = navigator
        self.window = window
        
    }
    
    func start() {
        if keystore.hasWallets {
            let wallet = keystore.recentlyUsedWallet ?? keystore.wallets.first!
//            showTransactions(for: wallet)
        } else {
            let welcomeScreen = WelcomeVC()
            let nav = UINavigationController(rootViewController: welcomeScreen)
            self.window.rootViewController = nav
            self.window.makeKeyAndVisible()
        }
        
    }
    
    
}
