//
//  GetNonceProvider.swift
//  TomoWallet
//
//  Created by TomoChain on 8/27/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//
import Foundation
import BigInt
import Result
import TrustCore
import Moya

protocol NonceProvider {
    var remoteNonce: BigInt? { get }
    var latestNonce: BigInt? { get }
    var nextNonce: BigInt? { get }
    var nonceAvailable: Bool { get }
    func getNextNonce(force: Bool, completion: @escaping (Result<BigInt, AnyError>) -> Void)
}

final class GetNonceProvider: NonceProvider {
    let storage: TransactionsStorage
    let server: RPCServer
    let address: Address
    var remoteNonce: BigInt? = .none
    let provider: MoyaProvider<RPCApi>
    var latestNonce: BigInt? {
        guard let nonce = storage.latestTransaction(for: address, coin: server.coin)?.nonce else {
            return .none
        }
        let remoteNonceInt = remoteNonce ?? BigInt(-1)
        return max(BigInt(nonce), remoteNonceInt)
    }
    
    var nextNonce: BigInt? {
        guard let latestNonce = latestNonce else {
            return .none
        }
        return latestNonce + 1
    }
    
    var nonceAvailable: Bool {
        return latestNonce != nil
    }
    
    init(
        storage: TransactionsStorage,
        server: RPCServer,
        address: Address,
        provider:MoyaProvider<RPCApi>
        ) {
        self.storage = storage
        self.server = server
        self.address = address
        self.provider = provider
        
        fetchLatestNonce()
    }
    
    func fetchLatestNonce() {
        fetch { _ in }
    }
    
    func getNextNonce(force: Bool = false, completion: @escaping (Result<BigInt, AnyError>) -> Void) {
        guard let nextNonce = nextNonce, force == false else {
            return fetchNextNonce(completion: completion)
        }
        completion(.success(nextNonce))
    }
    
    func fetchNextNonce(completion: @escaping (Result<BigInt, AnyError>) -> Void) {
        fetch { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let nonce):
                let res = self.nextNonce ?? nonce + 1
                completion(.success(res))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetch(completion: @escaping (Result<BigInt, AnyError>) -> Void) {
        self.provider.request(.getTransactionCount(server: self.server, address: address.description)) { (result) in
            switch result {
            case .success(let response):
                guard let responseValue:[String: Any] = (try! response.mapJSON() as? [String: Any]),let countHash = responseValue["result"] as? String, let count = BigInt(countHash.drop0x, radix: 16) else{
                    return
                }
                let nonce = count - 1
                self.remoteNonce = nonce
                completion(.success(nonce))
            case .failure(let error):
                completion(.failure(AnyError(error)))
            }
        }
    }
}

