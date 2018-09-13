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
    func update(for transaction: Transaction, completion: @escaping (Result<(Transaction, TransactionState), MoyaError>) -> Void)
}


struct PendingTransaction: Decodable {
    var blockNumber: String = ""
    init(blockNumber: String) {
        self.blockNumber = blockNumber
    }
    enum CodingKeys: String, CodingKey {
        case blockNumber
    }
  
}
struct ReceiptTransaction: Decodable {
    var status: String = ""
    init(status: String) {
        self.status = status
    }
    enum CodingKeys: String, CodingKey {
        case status
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
    
    func update(for transaction: Transaction, completion: @escaping (Result<(Transaction, TransactionState), MoyaError>) -> Void) {
        provider.request(.getTransactionByHash(server: self.server, transaction: transaction)) { (result) in
            switch result{
            case .success(let response):
                guard let pendingTransaction = try? response.map(PendingTransaction.self, atKeyPath: "result", using: JSONDecoder()) else{
                    return completion(.success((transaction, .pending)))
                }
                let blockNumber = Int(BigInt(pendingTransaction.blockNumber.drop0x, radix: 16) ?? "")
                if blockNumber > 0{
                    self.getReceipt(for: transaction, completion: completion)
                }
            case .failure(let error):
                 completion(.failure(error))
            }
        }
    }
    private func getReceipt(for transaction: Transaction, completion: @escaping (Result<(Transaction, TransactionState), MoyaError>) -> Void) {
        provider.request(.getTransactionReceipt(server: self.server, transaction: transaction)) { (result) in
            switch result{
            case .success(let response):
                guard let receiptTransaction = try? response.map(ReceiptTransaction.self, atKeyPath: "result", using: JSONDecoder()) else{
                    return completion(.success((transaction, .error)))
                }
                let status = Int(BigInt(receiptTransaction.status.drop0x, radix: 16) ?? "")
                if status == 1{
                    completion(.success((transaction, .completed)))
                }else{
                     completion(.success((transaction, .error)))
                }
          
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
