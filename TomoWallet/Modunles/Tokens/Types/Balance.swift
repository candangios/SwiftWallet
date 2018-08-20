//
//  Balance.swift
//  TomoWallet
//
//  Created by TomoChain on 8/20/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import BigInt

protocol BalanceProtocol {
    var value: BigInt { get }
    var amountShort: String { get }
    var amountFull: String { get }
}
struct Balance: BalanceProtocol {
    let value: BigInt
    
    init(value: BigInt) {
        self.value = value
    }
    
    var isZero: Bool {
        return value.isZero
    }
    
    var amountShort: String {
        return EtherNumberFormatter.short.string(from: value)
    }
    
    var amountFull: String {
        return EtherNumberFormatter.full.string(from: value)
    }
}

