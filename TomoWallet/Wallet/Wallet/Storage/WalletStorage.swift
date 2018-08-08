//
//  WalletStorege.swift
//  TomoWallet
//
//  Created by TomoChain on 8/7/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import RealmSwift

class WalletStorage {
    let realm: Realm
    
    var addresses : [WalletAddress]{
        return Array(realm.objects(WalletAddress.self))
    }
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func get(for type: WalletType) -> WalletObject {
        let firstWallet = realm.objects(WalletObject.self).filter { $0.id == type.description }.first
        guard let foundWallet = firstWallet else {
            return WalletObject.from(type)
        }
        return foundWallet
    }
    
    func store(address: [WalletAddress]) {
        try? realm.write {
            realm.add(address, update: true)
        }
    }
    func delete(address: WalletAddress) {
        try? realm.write {
            realm.delete(address)
        }
    }
    
}
