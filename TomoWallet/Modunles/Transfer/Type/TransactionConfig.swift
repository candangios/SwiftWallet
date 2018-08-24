//
//  TransactionConfig.swift
//  TomoWallet
//
//  Created by TomoChain on 8/24/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import BigInt

struct TransactionConfiguretion {
    let gasPrice: BigInt
    let gasLimit: BigInt
    let data: Data
    let nonce: BigInt
    
}
