//
//  WalletCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/13/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import MBProgressHUD
protocol WalletCoordinator_Delegate: class {
    
}

class WalletCoordinator: Coordinator{

    
    var childCoordinators: [Coordinator] = []
    var navigationController: NavigationController
    weak var delegate: WalletCoordinator_Delegate?
    var entryPoint: WalletEntryPoint
    let keystore: Keystore
    
    init(keystore: Keystore, navigationController: NavigationController = NavigationController(isHiddenNavigationBar: true), entryPoint: WalletEntryPoint){
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .formSheet
        self.keystore = keystore
        self.entryPoint = entryPoint
    }

    
    func start() {
        switch entryPoint {
        case .welcome:
                break
//            if let _ = keystore.mainWallet {
//                setSelectCoin()
//            } else {
//                setWelcomeView()
//            }
        case .importWallet:
            if let _ = keystore.mainWallet {
//                setSelectCoin()
            } else {
//                setImportMainWallet()
            }
        case .createInstantWallet:
            createInstantWallet()
        }
    }
    func createInstantWallet() {
        let hud = MBProgressHUD.showAdded(to: navigationController.view, animated: true)
        hud.label.text = "Creating Wallet..."
        let password = PasswordGenerator.generateRandom()
        
    
        self.keystore.createAccount(with: password, coin: .ethereum) { (result) in
            switch result{
            case .success(let acount):
                self.keystore.exportMnemonic(wallet: acount, completion: { (mnemonicResult) in
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.navigationController.view, animated: true)
                    }
                    switch mnemonicResult{
                    case .success(let words):
                        print(words)
                        break
                    case .failure(let error):
                        print(error)
                        break
                    }
                })
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
}
