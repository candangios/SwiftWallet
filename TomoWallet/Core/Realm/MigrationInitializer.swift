//
//  MirgrationInitializer.swift
//  TomoWallet
//
//  Created by TomoChain on 8/14/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import RealmSwift
import TrustCore
final class MigrationInitializer: Initializer{
    let account: WalletInfo
    lazy var config: Realm.Configuration = {
        return RealmConfiguration.configuration(for: account)
    }()
    
    init(
        account: WalletInfo
        ) {
        self.account = account
    }
    func perform() {
        // mirgaration when changed Object at realm schema
        self.config.schemaVersion = Config.dbMigrationSchemaVersion
        config.migrationBlock = { migration, oldSchemaVersion in
           // do somethings
        }
        
    }
}

