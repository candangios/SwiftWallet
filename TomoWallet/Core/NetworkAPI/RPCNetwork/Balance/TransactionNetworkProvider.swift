//
//  TransactionNetworkProvider.swift
//  TomoWallet
//
//  Created by TomoChain on 9/13/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import Moya
import Result
import BigInt
protocol TransactionNetworkProvider {
    func update(for transaction: Transaction, completion: @escaping (Result<(Transaction, TransactionState), AnyError>) -> Void)
}


struct TransactionResponse: Decodable {
    var blockNumber: String = ""
    init(blockNumber: String) {
        self.blockNumber = blockNumber

    }
    
    enum CodingKeys: String, CodingKey {
        case blockNumber
    }
  
}

struct TransactionByHashResponse: Decodable {
    var jsonrpc: String = ""
    var id:String = ""
    var result: TransactionResponse
    init(jsonrpc: String, id: String, transactionResponse: TransactionResponse) {
        self.jsonrpc = jsonrpc
        self.id = id
        self.result = transactionResponse
    }
    
    enum CodingKeys: String, CodingKey {
        case jsonrpc
        case id
        case result
    }
}

final class TransactionsProvider: TransactionNetworkProvider {
    
    let server: RPCServer
    let provider: MoyaProvider<RPCApi>
    init(
        server: RPCServer,
        provider: MoyaProvider<RPCApi>
        ) {
        self.server = server
        self.provider = provider
    }
    
    func update(for transaction: Transaction, completion: @escaping (Result<(Transaction, TransactionState), AnyError>) -> Void) {
        provider.request(.getTransactionByHash(server: self.server, transaction: transaction)) { (result) in
            switch result{
            case .success(let response):
                do {
                    let a  = try! response.mapString()
                
                    print(a)
                    let transactionByHashResponsense = try? JSONDecoder().decode(TransactionByHashResponse.self, from: response.data)
                    print(transactionByHashResponsense)
//                    guard let value = BigInt(balanceDecodable.result.drop0x, radix: 16) else{
//                        return seal.reject(CookiesStoreError.empty)
//                    }
//                    let balance = Balance(value: value)
//                    seal.fulfill(balance.value)
                } catch {
                     completion(.success((transaction, .error)))
                }
                
            case .failure(_):
                
                 completion(.success((transaction, .error)))
            }
        }
    }
}
