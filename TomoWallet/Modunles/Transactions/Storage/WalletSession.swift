//
//  WalletSession.swift
//  TomoWallet
//
//  Created by TomoChain on 8/14/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import RealmSwift

final class WalletSession {
    let account: WalletInfo
    let config: Config
    let realm: Realm
    let sharedRealm: Realm
    var sessionID: String {
        return "\(account.description))"
    }
    lazy var walletStorage: WalletStorage = {
        return WalletStorage(realm: sharedRealm)
    }()
    lazy var tokensStorage: TokensDataStore = {
        return TokensDataStore(account: account, realm: realm)
    }()
    lazy var transactionsStorage: TransactionsStorage = {
        return TransactionsStorage(realm: realm, account: account)
    }()
    
    lazy var currentRPC: RPCServer = {
        return account.coin!.server
    }()
    
    init(
        account: WalletInfo,
        realm: Realm,
        sharedRealm: Realm,
        config: Config
        ) {
        self.account = account
        self.realm = realm
        self.sharedRealm = sharedRealm
        self.config = config
    }

}
