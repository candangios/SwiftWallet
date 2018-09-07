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
struct RPCResultsDecodable: Decodable {
    let result: String
    let jsonrpc: String
    let id :Int64
    
    
    private enum keys: String, CodingKey {
        case result
        case jsonrpc
        case id
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: keys.self)
        self.result = try values.decode(String.self, forKey: .result)
        self.jsonrpc = try values.decode(String.self, forKey: .jsonrpc)
        self.id = try values.decode(Int64.self, forKey: .id)
    }
    
}


