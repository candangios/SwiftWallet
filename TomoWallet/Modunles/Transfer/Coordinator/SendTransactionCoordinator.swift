//
//  SendTransactionCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/27/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import Foundation
import Result
import Moya
import BigInt

final class SendTransactionCoordinator{
    private let keystore: Keystore
    let session: WalletSession
    let formatter = EtherNumberFormatter.full
    let confirmType: ConfirmType
    let server: RPCServer
    
    let provider = ApiProviderFactory.makeRPCNetworkProvider()
    
    init(
        session: WalletSession,
        keystore: Keystore,
        confirmType: ConfirmType,
        server: RPCServer
        ) {
        self.session = session
        self.keystore = keystore
        self.confirmType = confirmType
        self.server = server
    }
    
    func send(transaction: SignTransaction,completion: @escaping (Result<ConfirmResult, AnyError>) -> Void) {
        if transaction.nonce >= 0 {
            signAndSend(transaction: transaction, completion: completion)
        } else {
            provider.request(.getTransactionCount(server: server, address: transaction.account.address.description)) { (result) in
                switch result{
                case .success(let response):
                    guard let responseValue:[String: Any] = (try! response.mapJSON() as? [String: Any]),let countHash = responseValue["result"] as? String, let count = BigInt(countHash.drop0x, radix: 16) else{
                        return
                    }
                    let transaction = self.appendNonce(to: transaction, currentNonce: count)
                    self.signAndSend(transaction: transaction, completion: completion)
                case .failure(let error):
                    completion(.failure(AnyError(error)))
                }
            }
            
        }
    }
    
    private func appendNonce(to: SignTransaction, currentNonce: BigInt) -> SignTransaction {
        return SignTransaction(
            value: to.value,
            account: to.account,
            to: to.to,
            nonce: currentNonce,
            data: to.data,
            gasPrice: to.gasPrice,
            gasLimit: to.gasLimit,
            chainID: to.chainID,
            localizedObject: to.localizedObject
        )
    }
    
    
    private func signAndSend(transaction: SignTransaction,completion: @escaping (Result<ConfirmResult, AnyError>) -> Void) {
        let signedTransaction = keystore.signTransaction(transaction)
        switch signedTransaction {
        case .success(let data):
            approve(confirmType: confirmType, transaction: transaction, data: data, completion: completion)
        case .failure(let error):
            completion(.failure(AnyError(error)))
        }
    }
    
    private func approve(confirmType: ConfirmType, transaction: SignTransaction, data: Data, completion: @escaping (Result<ConfirmResult, AnyError>) -> Void) {
        let id = data.sha3(.keccak256).hexEncoded
        let sentTransaction = SentTransaction(
            id: id,
            original: transaction,
            data: data
        )
        let dataHex = data.hexEncoded
        switch confirmType {
        case .sign:
            completion(.success(.sentTransaction(sentTransaction)))
        case .signThenSend:      
            provider.request(.sendRawTransaction(server: server, signedTransaction: dataHex)) { (result) in
                switch result {
                case .success(let result):
        
//                        let a = try? result.mapString()
//                        print(a)
                    
                    completion(.success(.sentTransaction(sentTransaction)))
                  
                case .failure(let error):
                    completion(.failure(AnyError(error)))
                }
            }

        }
    }


}

