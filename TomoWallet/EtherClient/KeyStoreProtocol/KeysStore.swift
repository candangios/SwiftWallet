//
//  KeysStore.swift
//  TomoWallet
//
//  Created by TomoChain on 8/6/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore
import TrustKeystore
import Result

protocol KeysStore {
    var hasWallet: Bool { get };
    var mainWallet: WalletInfo? { get };
    var wallets:[WalletInfo] { get }
    var keysDirectory: URL { get }
//    var storage: WalletStorage { get }
    var recentlyUsedWallet: WalletInfo? { get set }
    @available(iOS 10.0, *)
    func createAccount(with password: String, completion: @escaping(Result<Wallet, KeystoreError>) -> Void)
 
    
}
