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

import Moya



protocol BalanceNetworkProvider {
    var addressUpdate: EthereumAddress { get }
    func balance() -> Promise<BigInt>
}
final class CoinNetworkProvider: BalanceNetworkProvider {
    let server: RPCServer
    let address: Address
    let addressUpdate: EthereumAddress
    let provider: MoyaProvider<RPCApi>
    
    init(
        server: RPCServer,
        address: Address,
        addressUpdate: EthereumAddress,
        provider: MoyaProvider<RPCApi>
        ) {
        self.server = server
        self.address = address
        self.addressUpdate = addressUpdate
        self.provider = provider
    }
    
    func balance() -> Promise<BigInt> {
        return Promise { seal in
            provider.request(.getBalanceCoin(server: self.server, address: address.description), completion: { (result) in
                switch result {
                case .success(let response):
                    break
//                    print(response.statusCode)
//                    do {
//
//                        let responseJSON = try response.mapJSON()
//                        print(responseJSON)
////                        if let dic = responseJSON as? NSDictionary{
////                            BigInt
//////                            let balance = Balance(value: responseJSON.va)
////                        }
//                    } catch {
//                        seal.reject(error)
//                    }
                case .failure(let error):
                    seal.reject(error)
                }
            })
//            let request = RPCServiceRequest(for: server, batch: BatchFactory().create(BalanceRequest(address: address.description)))
//            Session.send(request) { result in
//                switch result {
//                case .success(let balance):
//                    seal.fulfill(balance.value)
//                case .failure(let error):
//                    seal.reject(error)
//                }
//            }
        }
    }
}
