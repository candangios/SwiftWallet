//
//  TokensDataStore.swift
//  TomoWallet
//
//  Created by TomoChain on 8/14/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import RealmSwift
import Result
import TrustCore

class TokensDataStore {
    let realm: Realm
    let account: WalletInfo
    
    init(account: WalletInfo, realm: Realm) {
        self.account = account
        self.realm = realm
    }
}

extension Coin {
    var server: RPCServer {
        switch self {
        case .bitcoin: return RPCServer.main //TODO
        case .ethereum: return RPCServer.main
        case .ethereumClassic: return RPCServer.classic
        case .gochain: return RPCServer.gochain
        case .callisto: return RPCServer.callisto
        case .poa: return RPCServer.poa
        }
    }
}
