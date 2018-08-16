//
//  WalletCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/13/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore
import TrustKeystore
import UIKit

protocol WalletCoordinator_Delegate: class {
    
    func didFinish(with account: WalletInfo, in coordinator: WalletCoordinator)
    func didCancel(in coordinator: WalletCoordinator)
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
        self.navigationController.displayLoading(text: "Creating Wallet...", animated: true)
        let password = PasswordGenerator.generateRandom()
        self.keystore.createAccount(with: password, coin: .ethereum) { (result) in
            switch result{
            case .success(let wallet):
                self.keystore.exportMnemonic(wallet: wallet, completion: { (mnemonicResult) in
                   self.navigationController.hideLoading(animated: true)
                    switch mnemonicResult{
                    case .success(let words):
                        self.pushBackup(for: wallet, words: words)
                       
                    case .failure(let error):
                        self.navigationController.displayError(error: error)
                    }
                })
            case .failure(let error):
                self.navigationController.displayError(error: error)
            }
        }
    }
    
    func pushBackup(for wallet: Wallet, words: [String]) {
        let controller = ConfirmVC(account: wallet, words: words, mode: .showAndVerify)
        controller.delegate = self
       
        navigationController.pushViewController(controller, animated: true)
    }
}

extension WalletCoordinator: PassphraseVC_Delegate{
    func didPressVerify(in controller: ConfirmVC, with account: Wallet, words: [String]) {
       
//        self.delegate?.didFinish(with: account., in: self)
    }
    
    func didSkip(in controller: ConfirmVC, with account: Wallet) {
        self.delegate?.didCancel(in: self)
    }
    
    
}
