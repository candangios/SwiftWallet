//
//  Token.swift
//  TomoWallet
//
//  Created by TomoChain on 8/23/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore

struct Token {
    let address: EthereumAddress
    let name: String
    let symbol: String
    let decimals: Int
}

