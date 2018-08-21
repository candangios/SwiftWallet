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
    let result: String

    
    init(value: BigInt) {
        self.value = value
        result = ""
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
    
    enum keys: String, CodingKey {
        case result
    }
    
  

}
extension Balance: Decodable{
    
    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: keys.self)
        
        
        result = try values.decode(String.self, forKey: .result)
        self.value = try BigInt(from: decoder)
        
      
    }
}


