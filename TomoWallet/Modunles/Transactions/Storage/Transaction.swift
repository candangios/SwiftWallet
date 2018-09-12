//
//  Transaction.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import RealmSwift
import TrustCore


enum TransactionDirection {
    case incoming
    case outgoing
    case sendToYourself
}

final class Transaction: Object, Decodable {
    @objc dynamic var id: String = ""
    @objc dynamic var uniqueID: String = ""
    @objc dynamic var blockNumber: Int = 0
    @objc dynamic var from = ""
    @objc dynamic var to = ""
    @objc dynamic var value = ""
    @objc dynamic var gas = ""
    @objc dynamic var gasPrice = ""
    @objc dynamic var gasUsed = ""
    @objc dynamic var nonce: Int = 0
    @objc dynamic var date = Date()
    @objc dynamic var internalState: Int = TransactionState.completed.rawValue
    
    @objc private dynamic var rawCoin = -1
    public var coin: Coin {
        get { return Coin(rawValue: rawCoin)! }
        set { rawCoin = newValue.rawValue }
    }
    
    var localizedOperations = List<LocalizedOperationObject>()
    
    var direction: TransactionDirection?
  
    convenience init(
        id: String,
        blockNumber: Int,
        from: String,
        to: String,
        value: String,
        gas: String,
        gasPrice: String,
        gasUsed: String,
        nonce: Int,
        date: Date,
        coin: Coin,
        localizedOperations: [LocalizedOperationObject],
        state: TransactionState
        ) {
        self.init()
        self.id = id
        self.uniqueID = from + "-" + String(nonce)
        self.blockNumber = blockNumber
        self.from = from
        self.to = to
        self.value = value
        self.gas = gas
        self.gasPrice = gasPrice
        self.gasUsed = gasUsed
        self.nonce = nonce
        self.date = date
        self.coin = coin
        self.internalState = state.rawValue
        
        let list = List<LocalizedOperationObject>()
        localizedOperations.forEach { element in
            list.append(element)
        }
        
        self.localizedOperations = list
    }
    
    private enum TransactionCodingKeys: String, CodingKey {
        case id = "hash"
        case blockNumber
        case from
        case to
        case value
        case gas
        case gasPrice
        case gasUsed
        case nonce // Here we need to convert (from Int)]
        case timeStamp // Convert from timestamp
        case operations // Operations needs custom decoding
        case error // Only to throw
        case coin
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TransactionCodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let blockNumber = try container.decodeIfPresent(Int.self, forKey: .blockNumber) ?? 0
        let from = try container.decodeIfPresent(String.self, forKey: .from) ?? ""
        let to = try container.decodeIfPresent(String.self, forKey: .to) ?? ""
        let value = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
        let gas = try container.decodeIfPresent(Int.self, forKey: .gas) ?? 0
        let gasPrice = try container.decodeIfPresent(String.self, forKey: .gasPrice) ?? ""
        let gasUsed = try container.decodeIfPresent(Int.self, forKey: .gasUsed) ?? 0
        let rawNonce = try container.decodeIfPresent(Int.self, forKey: .nonce) ?? 0
        let timeStamp = try container.decodeIfPresent(Int.self, forKey: .timeStamp) ?? 0
        let error = try container.decodeIfPresent(Bool.self, forKey: .error) ?? false
        let operations = [LocalizedOperationObject]()
        
        guard
            let fromAddress = EthereumAddress(string: from) else {
                let context = DecodingError.Context(codingPath: [TransactionCodingKeys.from],
                                                    debugDescription: "Address can't be decoded as a TrustKeystore.Address")
                throw DecodingError.dataCorrupted(context)
        }
        
        let state: TransactionState = {
            if error == false {
                return .completed
            }
            return .error
        }()
        
    
        
        self.init(
            id: id,
            blockNumber: blockNumber,
            from: fromAddress.description,
            to: to,
            value: value,
            gas: String(gas),
            gasPrice: gasPrice,
            gasUsed: String(gasUsed),
            nonce: rawNonce,
            date: Date(timeIntervalSince1970: TimeInterval(timeStamp)),
            coin: Coin.tomo,
            localizedOperations: operations,
            state: state
        )
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
    
    var contractAddress: EthereumAddress? {
        guard
            let operation = operation,
            let contract = operation.contract,
            let contractAddress = EthereumAddress(string: contract) else {
                return .none
        }
        return contractAddress
    }
}

extension Transaction {
    var operation: LocalizedOperationObject? {
        return localizedOperations.first
    }
}
