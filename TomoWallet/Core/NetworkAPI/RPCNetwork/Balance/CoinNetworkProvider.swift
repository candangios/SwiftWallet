//
//  BalanceNetworkProvice.swift
//  TomoWallet
//
//  Created by TomoChain on 8/20/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore
import PromiseKit
import BigInt
import APIKit
import JSONRPCKit

protocol BalanceNetworkProvider {
    var addressUpdate: EthereumAddress { get }
    func balance() -> Promise<BigInt>
}
final class CoinNetworkProvider: BalanceNetworkProvider {
    let server: RPCServer
    let address: Address
    let addressUpdate: EthereumAddress
    
    init(
        server: RPCServer,
        address: Address,
        addressUpdate: EthereumAddress
        ) {
        self.server = server
        self.address = address
        self.addressUpdate = addressUpdate
    }
    
    func balance() -> Promise<BigInt> {
        return Promise { seal in
            let request = RPCServiceRequest(for: server, batch: BatchFactory().create(BalanceRequest(address: address.description)))
            Session.send(request) { result in
                switch result {
                case .success(let balance):
                    seal.fulfill(balance.value)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
