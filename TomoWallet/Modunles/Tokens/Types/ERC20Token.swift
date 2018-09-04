//
//  ERC20Token.swift
//  TomoWallet
//
//  Created by TomoChain on 9/4/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore
struct ERC20Token{
    let contract: Address
    let name: String
    let symbol: String
    let decimals: Int
    let coin: Coin
}
