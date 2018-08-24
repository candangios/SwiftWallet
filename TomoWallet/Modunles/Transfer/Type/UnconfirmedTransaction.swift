//
//  UnconfirmedTransaction.swift
//  TomoWallet
//
//  Created by TomoChain on 8/24/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import BigInt
import TrustCore

struct UnconfirmedTransaction {
    let transfer: Transfer
    let value: BigInt
    let to : EthereumAddress
    let data: Data?
    
    let gasLimit: BigInt
    let gasPrice: BigInt
    let nonce: BigInt
}
