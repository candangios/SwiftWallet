//
//  ContractNetworkProvider.swift
//  TomoWallet
//
//  Created by TomoChain on 9/7/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//
import Foundation
import TrustCore
import PromiseKit
import BigInt
import Moya
import CryptoSwift

import APIKit
import JSONRPCKit

protocol ContractInfoNetworkProvider {
    func name(contracsAddress: EthereumAddress) -> Promise<String>
    func symbol(contracsAddress: EthereumAddress) -> Promise<String>
    func decimals(contracsAddress: EthereumAddress) -> Promise<BigInt>
}
final class ContractNetworkProvider: ContractInfoNetworkProvider {
 
    
    let server: RPCServer
    let provider: MoyaProvider<RPCApi>
    
    init(server: RPCServer, provider: MoyaProvider<RPCApi>){
        self.server = server
        self.provider = provider
    }
    
    func symbol(contracsAddress: EthereumAddress) -> Promise<String> {
        return Promise { seal in
            let encoded = ERC20Encoder.encodeSymbol()
            provider.request(.getTokenSymbol(server: self.server, contract: contracsAddress.description, data: encoded.hexEncoded), completion: { (result) in
                switch result {
                case .success(let response):
                    do {
                        let balanceDecodable = try response.map(RPCResultsDecodable.self)
                        guard let value = BigInt(balanceDecodable.result.drop0x, radix: 16) else{
                            return seal.reject(CookiesStoreError.empty)
                        }
                        let data = Data(hexString: balanceDecodable.result)
                        let decoder = String.init(data: data!, encoding: .utf8)
              
                   
                        seal.fulfill(decoder!)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            })
            
        }
    }
    
    func decimals(contracsAddress: EthereumAddress) -> Promise<BigInt> {
        return Promise { seal in
            let encoded = ERC20Encoder.encodeDecimals()
            provider.request(.getTokenDecimals(server: self.server, contract: contracsAddress.description, data: encoded.hexEncoded), completion: { (result) in
                switch result {
                case .success(let response):
                    do {
                        let decimalsDecodable = try response.map(RPCResultsDecodable.self)
                        guard let value = BigInt(decimalsDecodable.result.drop0x, radix: 16) else{
                            return seal.reject(CookiesStoreError.empty)
                        }
                        let balance = Balance(value: value)
                      //  print(balance.value)
                        seal.fulfill(value)

                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            })
            
        }
    }
    
    func name(contracsAddress: EthereumAddress) -> Promise<String> {
        return Promise { seal in
            let encoded = ERC20Encoder.encodeName()
            provider.request(.getTokenName(server: self.server, contract: contracsAddress.description, data: encoded.hexEncoded), completion: { (result) in
                switch result {
                case .success(let response):
                    do {
                        let balanceDecodable = try response.map(RPCResultsDecodable.self)
                        guard let value = BigInt(balanceDecodable.result.drop0x, radix: 16) else{
                            return seal.reject(CookiesStoreError.empty)
                        }
                        let data = Data(hexString: balanceDecodable.result)
                        let decoder = String.init(data: data!, encoding: .utf8)
                        seal.fulfill(decoder!)
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

