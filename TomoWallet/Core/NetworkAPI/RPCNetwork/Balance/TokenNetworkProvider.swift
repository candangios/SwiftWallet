//
//  TokenNetworkProvice.swift
//  TomoWallet
//
//  Created by TomoChain on 8/20/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore
import PromiseKit
import BigInt
import Moya


final class TokenNetworkProvider: BalanceNetworkProvider {
    
    let server: RPCServer
    let address: EthereumAddress
    let contract: EthereumAddress
    let addressUpdate: EthereumAddress
    let provider: MoyaProvider<RPCApi>
    
    
    init(
        server: RPCServer,
        address: EthereumAddress,
        contract: EthereumAddress,
        addressUpdate: EthereumAddress,
        provider: MoyaProvider<RPCApi>
        ) {
        self.server = server
        self.address = address
        self.contract = contract
        self.addressUpdate = addressUpdate
        self.provider = provider
    }
        
    func balance() -> Promise<BigInt> {
        return Promise { seal in
            let encoded = ERC20Encoder.encodeBalanceOf(address: address)
            provider.request(.getBalanceToken(server: self.server, contract: self.contract.description, data: encoded.hexEncoded), completion: { (result) in
                switch result {
                case .success(let response):
                    do {
                        let balanceDecodable = try response.map(RPCResultsDecodable.self)
                        guard let value = BigInt(balanceDecodable.result.drop0x, radix: 16) else{
                            return seal.reject(CookiesStoreError.empty)
                        }
                        let balance = Balance(value: value)
                        seal.fulfill(balance.value)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
    }
}

