//
//  Account.swift
//  TomoWallet
//
//  Created by TomoChain on 8/23/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustKeystore
import TrustCore
extension Account{
    var coin: Coin?{
        return Coin(rawValue: derivationPath.coinType)
    }
    
    var description: String {
        return derivationPath.description + "-" + address.description
    }
}
