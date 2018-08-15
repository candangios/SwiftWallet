//
//  SharedMigrationInitializer.swift
//  TomoWallet
//
//  Created by TomoChain on 8/14/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import RealmSwift
final class SharedMigrationInitializer: Initializer{
    lazy var config: Realm.Configuration = {
        return RealmConfiguration.sharedConfiguration()
    }()
    
    init() { }
    
    func perform() {
        config.schemaVersion = Config.dbMigrationSchemaVersion
        config.migrationBlock = { migration, oldSchemaVersion in
            // do somethings here
        }
    }
}
