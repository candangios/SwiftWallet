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
    func didCancel(in coordinator: WalletCoordinator, account: WalletInfo)
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
        case .importWallet:
            self.setImportMainWallet()
        case .createInstantWallet:
            self.createInstantWallet()
        }
    }
    func createInstantWallet() {
        self.navigationController.displayLoading(text: "Creating Wallet...", animated: true)
        let password = PasswordGenerator.generateRandom()
  
        self.keystore.createAccount(with: password, coin: .tomo) { (result) in
            switch result{
            case .success(let wallet):
                self.keystore.exportMnemonic(wallet: wallet, completion: { (mnemonicResult) in
                   self.navigationController.hideLoading(animated: true)
                    switch mnemonicResult{
                    case .success(let words):
                        self.markAsMainWallet(for: wallet)
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
    
    
    private func markAsMainWallet(for account: Wallet) {
        let type = WalletType.hd(account)
        let wallet = WalletInfo(type: type, info: keystore.storage.get(for: type))
        markAsMainWallet(for: wallet)
    }
    
    private func markAsMainWallet(for wallet: WalletInfo) {
        let initialName = "MainWallet"
        keystore.store(object: wallet.info, fields: [
            .name(initialName),
            .mainWallet(true),
        ])
    }
    
    func setImportMainWallet(){
        let controller = ImportWalletVC(keystore: self.keystore, for: .tomo)
        controller.delegate = self
        self.navigationController.pushViewController(controller, animated: true)

    }
    
    func createNameWallet(wallet: WalletInfo, type: WalletDoneType) {
        self.delegate?.didFinish(with: wallet, in: self)
        
    }
}
//MARK: -  Coordinator create new wallet delegate
extension WalletCoordinator: ConfrimVC_Delegate{
    func didPressVerify(in controller: ConfirmVC, with account: Wallet, words: [String]) {
        let passPhrase = PassphraseVC(account: account, words: words)
        passPhrase.delegate = self
        self.navigationController.pushViewController(passPhrase, animated: true)
    }
    
    func didSkip(in controller: ConfirmVC, with account: Wallet) {
        let type = WalletType.hd(account)
        let walletInfo = WalletInfo(type: type, info: keystore.storage.get(for: type))
        keystore.store(object: walletInfo.info, fields: [
            .backup(false),
            ])
        createNameWallet(wallet: walletInfo, type: .created)
    }
}
extension WalletCoordinator: PassphraseVC_Delegate{
    func didPressVerify(in controller: PassphraseVC, with account: Wallet, words: [String]) {
        let veryfirmVC = VerifyPassphraseVC(account: account, words: words, mode: .showAndVerify)
        veryfirmVC.delegate = self
        self.navigationController.pushViewController(veryfirmVC, animated: true)
        
    }
    
    func didSkip(in controller: PassphraseVC, with account: Wallet) {
        self.navigationController.popViewController(animated: true)
//
    }
}
extension WalletCoordinator: VerifyPassphraseVC_Delegate{
    func didFinish(in controller: VerifyPassphraseVC, with account: Wallet) {
    
    }
    
    func didSkip(in controller: VerifyPassphraseVC, with account: Wallet) {
        
    }
}
//MARK: -  Coordinator import wallet delegate
extension WalletCoordinator: ImportWalletVC_Delegate{
    func didImportAccount(account: WalletInfo, fields: [WalletInfoField], in viewController: ImportWalletVC) {
        keystore.store(object: account.info, fields: fields)
        createNameWallet(wallet: account, type: .imported)

    }
}
