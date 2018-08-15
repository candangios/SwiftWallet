//
//  TokensPrice.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
struct TokensPrice: Encodable {
    let currency: String
    let tokens: [TokenPrice]
    
}
struct TokenPrice: Encodable {
    let contract: String
    let symbol: String
    
}
