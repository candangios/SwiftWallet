//
//  WalletObject.swift
//  TomoWallet
//
//  Created by TomoChain on 8/6/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import RealmSwift
import TrustCore
import Realm
final class WalletObject: Object{
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var completedBackup: Bool = false
    @objc dynamic var mainWallet: Bool = false
    @objc dynamic var balance: String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
    static func from(_ type: WalletType) -> WalletObject{
        let info = WalletObject()
        info.id = type.description
        return info
    }

}
