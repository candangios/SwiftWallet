//
//  TransactionObject.swift
//  TomoWallet
//
//  Created by TomoChain on 9/11/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import RealmSwift
import TrustCore


final class TransactionObject: Object, Decodable {
    @objc dynamic var id: String = ""
    @objc dynamic var uniqueID: String = ""
    @objc dynamic var blockNumber: Int = 0
    @objc dynamic var from = ""
    @objc dynamic var to = ""
    @objc dynamic var value = ""
    @objc dynamic var gas = ""
    @objc dynamic var gasPrice = ""
    @objc dynamic var date = Date()
    @objc dynamic var internalState: Int = TransactionState.completed.rawValue
    
    var direction: TransactionDirection?
    
    convenience init(
        id: String,
        blockNumber: Int,
        from: String,
        to: String,
        value: String,
        gas: String,
        gasPrice: String,
        date: Date,
        state: TransactionState
        ) {
        self.init()
        self.id = id
        self.uniqueID = from + "-"
        self.blockNumber = blockNumber
        self.from = from
        self.to = to
        self.value = value
        self.gas = gas
        self.gasPrice = gasPrice
        self.date = date
        self.internalState = state.rawValue
    }
    
    private enum TransactionCodingKeys: String, CodingKey {
        case hash 
        case blockNumber
        case from
        case to
        case value
        case gas
        case gasPrice
        case timeStamp // Convert from timestamp
        case isError // Only to throw
        case hehe
      
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TransactionCodingKeys.self)
        let id = try container.decode(String.self, forKey: .hash)
        let blockNumber = try container.decode(Int.self, forKey: .blockNumber)
        let from = try container.decode(String.self, forKey: .from)
        let to = try container.decode(String.self, forKey: .to)
        let value = try container.decode(String.self, forKey: .value)
        let gas = try container.decode(Int.self, forKey: .gas)
        let gasPrice = try container.decode(String.self, forKey: .gasPrice)
        let error = try container.decode(Bool.self, forKey: .isError)
        if(container.contains(.hehe)){
            let hehe = try container.decode(Bool.self, forKey: .hehe)
        }
        
        let timeStamp = 0
      
        
        let state: TransactionState = {
            if error == false {
                return .error
            }
            return .completed
        }()
        self.init(id: id, blockNumber: blockNumber, from: from, to: to, value: value, gas: String( gas), gasPrice: gasPrice, date: Date(timeIntervalSince1970: TimeInterval(timeStamp) ?? 0), state: state)
    }
    
    override static func primaryKey() -> String? {
        return "uniqueID"
    }
    
    var state: TransactionState {
        return TransactionState(int: self.internalState)
    }
    
    var toAddress: EthereumAddress? {
        return EthereumAddress(string: to)
    }
    
    var fromAddress: EthereumAddress? {
        return EthereumAddress(string: from)
    }
}
