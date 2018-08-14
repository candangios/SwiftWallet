//
//  TransactionStore.swift
//  TomoWallet
//
//  Created by TomoChain on 8/14/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import RealmSwift
final class TransactionsStorage{
    let realm: Realm
    let account: WalletInfo
    
    init(account: WalletInfo, realm: Realm) {
        self.account = account
        self.realm = realm
    }
    
}
