//
//  EtherKeyStore.swift
//  TomoWallet
//
//  Created by TomoChain on 8/7/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import KeychainSwift
import Result
import TrustKeystore
import TrustCore
import UIKit
class EtherKeyStore: Keystore {
    struct Keys {
        static let recentlyUsedAddress: String = "recentlyUsedAddress"
        static let recentlyUsedWallet: String = "recentlyUsedWallet"
    }
    private let keychain: KeychainSwift
    private let datadir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    let keyStore: KeyStore
    private let defaultKeychainAccess: KeychainSwiftAccessOptions = .accessibleWhenUnlockedThisDeviceOnly
    let keysDirectory: URL
    let userDefaults: UserDefaults
    let storage: WalletStorage
    
    public init(
        keychain: KeychainSwift = KeychainSwift(keyPrefix: Constants.keychainKeyPrefix),
        keysSubfolder: String = "/keystore",
        userDefaults: UserDefaults = UserDefaults.standard,
        storage: WalletStorage
        ) {
        self.keysDirectory = URL(fileURLWithPath: datadir! + keysSubfolder)
        self.keychain = keychain
        self.keychain.synchronizable = false
        self.keyStore =  try! KeyStore(keyDirectory: keysDirectory)
        self.userDefaults = userDefaults
        self.storage = storage
    }
    
    var hasWallets: Bool  {
        return !wallets.isEmpty
    }
    
    var mainWallet: WalletInfo?
    
    var wallets: [WalletInfo] {
        return [
            keyStore.wallets.filter { !$0.accounts.isEmpty }.compactMap {
                switch $0.type {
                case .encryptedKey:
                    let type = WalletType.privateKey($0)
                    return WalletInfo(type: type, info: storage.get(for: type))
                case .hierarchicalDeterministicWallet:
                    let type = WalletType.hd($0)
                    return WalletInfo(type: type, info: storage.get(for: type))
                }
                }.filter { !$0.accounts.isEmpty },
            storage.addresses.compactMap {
                guard let address = $0.address else { return .none }
                let type = WalletType.address($0.coin, address)
                return WalletInfo(type: type, info: storage.get(for: type))
            },
            ].flatMap { $0 }.sorted(by: { $0.info.createdAt < $1.info.createdAt })
    }
    
    var recentlyUsedWallet: WalletInfo?{
        set {
            keychain.set(newValue?.description ?? "", forKey: Keys.recentlyUsedWallet, withAccess: defaultKeychainAccess)
        }
        get {
            let walletKey = keychain.get(Keys.recentlyUsedWallet)
            let foundWallet = wallets.filter { $0.description == walletKey }.first
            guard let wallet = foundWallet else {
                // Old way to match recently selected address
                let address = keychain.get(Keys.recentlyUsedAddress)
                return wallets.filter {
                    $0.address.description == address || $0.description.lowercased() == address?.lowercased()
                    }.first
            }
            return wallet
        }
    }
    
    func createAccout(password: String) -> Wallet {
        let derivationPaths = Config.current.servers.map { $0.derivationPath(at: 0) }
        let wallet = try! keyStore.createWallet(
            password: password,
            derivationPaths: derivationPaths
        )
        let _ = setPassword(password, for: wallet)
        return wallet
    }
    
    func createAccout(password: String, coin: Coin) -> Wallet {
        let derivationPath = coin.derivationPath(at: 0)
        let wallet = try! keyStore.createWallet(
            password: password,
            derivationPaths: [derivationPath]
        )
        let _ = setPassword(password, for: wallet)
  
    
        return wallet
    
    }
    
    
    func getPassword(for account:Wallet) -> String? {
        let key = keychainKey(for: account)
        return keychain.get(key)
    }
    
    @discardableResult
    func setPassword(_ password: String, for account: Wallet) -> Bool {
        let key = keychainKey(for: account)
        return keychain.set(password, forKey: key, withAccess: defaultKeychainAccess)
    }
    internal func keychainKey(for account: Wallet) -> String {
        return account.identifier
    }
    
    
    // Async
    
    
    @available(iOS 10.0, *)
    
    func createAccount(with password: String, coin: Coin, completion: @escaping (Result<Wallet, KeystoreError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let account = self.createAccout(password: password, coin: coin)
            DispatchQueue.main.async {
                completion(.success(account))
            }
        }
    }
    
    func createAccount(with password: String, completion: @escaping (Result<Wallet, KeystoreError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let account = self.createAccout(password: password)
            DispatchQueue.main.async {
                completion(.success(account))
            }
        }
    }
    
    //MARK: - Import Wallet
    
    func importWallet(type: ImportType, coin: Coin, completion: @escaping (Result <WalletInfo, KeystoreError>) -> Void) {
        let newPassword = PasswordGenerator.generateRandom()
        switch type {
        case .keystore(let string, let password):
            importKeystore(value: string, password: password, newPassword: newPassword, coin: coin){(result) in
                switch result{
                case .success(let account):
                    completion(.success(account))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
        case .privatekey(let privatekey):
            let privateKeyData = PrivateKey(data: Data(hexString: privatekey)!)!
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                    let wallet = try self.keyStore.import(privateKey: privateKeyData, password: newPassword, coin: coin)
                    self.setPassword(newPassword, for: wallet)
                    DispatchQueue.main.async {
                        completion(.success(WalletInfo(type: .privateKey(wallet))))
                    }
                    
                }catch{
                    DispatchQueue.main.async {
                        completion(.failure(KeystoreError.failedToImportPrivateKey))
                    }
                    
                }
            }
        case .mnemonic(let words, _, let derivationPath):
            let mnemonicString = words.map{ String($0)}.joined(separator: " ")
            if !Crypto.isValid(mnemonic: mnemonicString){
                return completion(.failure(KeystoreError.invalidMnemonicPhrase))
            }
            do {
                let account = try keyStore.import(mnemonic: mnemonicString, encryptPassword: newPassword, derivationPath: derivationPath)
                self.setPassword(newPassword, for: account)
                completion(.success(WalletInfo(type: .hd(account))))
                
            }catch{
                return completion(.failure(KeystoreError.duplicateAccount))
            }
        case .address(let address):
            let watchWallet = WalletAddress(coin: coin, address: address)
            guard !storage.addresses.contains(watchWallet) else {
                return completion(.failure(.duplicateAccount))
            }
            storage.store(address: [watchWallet])
            completion(.success(WalletInfo(type: .address(coin, address))))
            
        }
    }
    func importKeystore(value: String, password: String, newPassword: String, coin: Coin, completion: @escaping (Result<WalletInfo, KeystoreError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.importKeystore(value: value, password: password, newPassword: newPassword, coin: coin)
            DispatchQueue.main.async {
                switch result {
                case .success(let account):
                    completion(.success(account))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func importKeystore(value: String, password: String, newPassword: String, coin: Coin) -> Result<WalletInfo, KeystoreError> {
        guard let data = value.data(using: .utf8) else {
            return (.failure(.failedToParseJSON))
        }
        do{
           // TODO: Blockchain. Pass blockchain ID
            let wallet = try keyStore.import(json: data, password: password, newPassword: newPassword, coin: coin)
            let _ = setPassword(newPassword, for: wallet)
            return .success(WalletInfo(type: .hd(wallet)))

        }catch{
            switch error {
            case KeyStore.Error.accountAlreadyExists:
                 return .failure(.duplicateAccount)
            default:
                return .failure(.failedToImport(error))
            }
        }
       
    }
    
    func importPrivateKey(privateKey: PrivateKey, password: String, coin: Coin) -> Result<WalletInfo, KeystoreError> {
        do {
            let wallet = try keyStore.import(privateKey: privateKey, password: password, coin: coin)
            let w = WalletInfo(type: .privateKey(wallet))
            let _ = setPassword(password, for: wallet)
            return .success(w)
        } catch {
            return .failure(.failedToImport(error))
        }

    }
    
    
    
    //MARK: - Export Wallet
    func export(account: Account, password: String, newPassword: String) -> Result<String, KeystoreError> {
        let result = self.exportData(account: account, password: password, newPassword: newPassword)
        switch result {
        case .success( let data):
            return .success(String(data: data, encoding: .utf8) ?? "")
        case .failure(let error):
            return .failure(error)
        }
        
    }
    
    func export(account: Account, password: String, newPassword: String, completion: @escaping (Result<String, KeystoreError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.export(account: account, password: password, newPassword: newPassword)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
    }
    
    func exportData(account: Account, password: String, newPassword: String) -> Result<Data, KeystoreError> {
        do {
            let data = try keyStore.export(wallet: account.wallet!, password: password, newPassword:newPassword)
            return (.success(data))
        }catch{
            return (.failure(.failedToDecryptKey))
        }
        
    }
    
    func exportPrivateKey(account: Account, completion: @escaping (Result<Data, KeystoreError>) -> Void) {
        guard let password = getPassword(for: account.wallet!) else{
            return completion(.failure(KeystoreError.accountNotFound))
        }
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                let privatekey = try account.privateKey(password: password).data
                DispatchQueue.main.async {
                    completion(.success(privatekey))
                }
            }catch{
                DispatchQueue.main.async {
                    completion(.failure(KeystoreError.accountNotFound))
                }
            }
        }
        
    }
    
    func exportMnemonic(wallet: Wallet, completion: @escaping (Result<[String], KeystoreError>) -> Void) {
        guard let password = getPassword(for: wallet) else {
            return completion(.failure(KeystoreError.accountNotFound))
        }
        DispatchQueue.global(qos: .unspecified).async {
            do{
                let mnemonic = try self.keyStore.exportMnemonic(wallet: wallet, password: password)
                let words = mnemonic.components(separatedBy: " ")
                DispatchQueue.main.async {
                    completion(.success(words))
                }
                
            }catch{
                DispatchQueue.main.async {
                    completion(.failure(KeystoreError.accountNotFound))
                }
            }
        }
    }
    
    func delete(wallet: Wallet) -> Result<Void, KeystoreError> {
        guard let password = getPassword(for: wallet) else {
            return .failure(KeystoreError.failedToDeleteAccount)
        }
        do{
            try keyStore.delete(wallet: wallet, password: password)
            return .success(())
            
        }catch{
            return .failure(KeystoreError.failedToDeleteAccount)
        }
    }
    
    func delete(wallet: WalletInfo, completion: @escaping (Result<Void, KeystoreError>) -> Void) {
        switch wallet.type {
        case .privateKey(let w),.hd(let w):
            let result = self.delete(wallet: w)
            DispatchQueue.global(qos: .unspecified).async {
                completion(result)
            }
        case .address(let coin, let address):
            let first = storage.realm.objects(WalletAddress.self).filter { $0.address == address && $0.coin == coin }.first
            guard let walletAddress = first else {
                return completion(.failure(KeystoreError.accountNotFound))
            }
            storage.delete(address: walletAddress)
            return completion(.success(()))
        }
    }
    
    func addAccount(to wallet: Wallet, derivationPaths: [DerivationPath]) -> Result<Void, KeystoreError> {
        guard let password = getPassword(for: wallet) else {
            return .failure(.failedToDeleteAccount)
        }
        do {
            let _ = try keyStore.addAccounts(wallet: wallet, derivationPaths: derivationPaths, password: password)
            return .success(())
        } catch {
            return .failure(KeystoreError.failedToAddAccounts)
        }
    }
    
    func update(wallet: Wallet) -> Result<Void, KeystoreError> {
        guard let password = getPassword(for: wallet) else {
            return .failure(.failedToDeleteAccount)
        }
        try? keyStore.update(wallet: wallet, password: password, newPassword: password)
        return .success(())
    }
    
    
    func store(object: WalletObject, fields: [WalletInfoField]) {
        try? storage.realm.write {
            for field in fields {
                switch field {
                case .name(let name):
                    object.name = name
                case .backup(let completedBackup):
                    object.completedBackup = completedBackup
                case .mainWallet(let mainWallet):
                    object.mainWallet = mainWallet
                case .balance(let balance):
                    object.balance = balance
                }
            }
            storage.realm.add(object, update: true)
        }
    }
 
}
