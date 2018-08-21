//
//  TokenNetworkProvice.swift
//  TomoWallet
//
//  Created by TomoChain on 8/20/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import Foundation
import TrustCore
import PromiseKit
import BigInt
import APIKit
import JSONRPCKit

import Alamofire

final class TokenNetworkProvider: BalanceNetworkProvider {
    
    let server: RPCServer
    let address: EthereumAddress
    let contract: EthereumAddress
    let addressUpdate: EthereumAddress
    
    init(
        server: RPCServer,
        address: EthereumAddress,
        contract: EthereumAddress,
        addressUpdate: EthereumAddress
        ) {
        self.server = server
        self.address = address
        self.contract = contract
        self.addressUpdate = addressUpdate
    }
    
    func balance() -> Promise<BigInt> {
        return Promise { seal in
            let encoded = ERC20Encoder.encodeBalanceOf(address: address)
            let request = RPCServiceRequest(
                for: server,
                batch: BatchFactory().create(CallRequest(to: contract.description, data: encoded.hexEncoded))
            )
            Session.send(request) { result in
                switch result {
                case .success(let balance):
                    guard let value = BigInt(balance.drop0x, radix: 16) else {
                        return seal.reject(CookiesStoreError.empty)
                    }
                    seal.fulfill(value)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

