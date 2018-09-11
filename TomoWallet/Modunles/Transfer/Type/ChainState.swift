    //
//  ChainState.swift
//  TomoWallet
//
//  Created by TomoChain on 8/24/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//



import Foundation
import BigInt
import Moya
final class ChainState{
    struct Keys {
        static let latestBlock = "chainID"
        static let gasPrice = "gasPrice"
    }
    
    let server: RPCServer
    let provider: MoyaProvider<RPCApi>
    
    private var latestBlockKey: String {
        return "\(server.chainID)-" + Keys.latestBlock
    }
    
    private var gasPriceBlockKey: String {
        return "\(server.chainID)-" + Keys.gasPrice
    }
    
    var chainStateCompletion: ((Bool, Int) -> Void)?
    
    var latestBlock: Int {
        get {
            return defaults.integer(forKey: latestBlockKey)
        }
        set {
            defaults.set(newValue, forKey: latestBlockKey)
        }
    }
    var gasPrice: BigInt? {
        get {
            guard let value = defaults.string(forKey: gasPriceBlockKey) else { return .none }
            return BigInt(value, radix: 10)
        }
        set { defaults.set(newValue?.description, forKey: gasPriceBlockKey) }
    }
    
    let defaults: UserDefaults
    
    var updateLatestBlock: Timer?
    
    init(
        server: RPCServer,
        provider: MoyaProvider<RPCApi>
        ) {
        self.server = server
        self.provider = provider
        self.defaults = Config.current.defaults
        fetch()
    }
    
    func start() {
        fetch()
    }
    
    @objc func fetch() {
        getLastBlock()
        getGasPrice()
    }
    private func getLastBlock() {
        provider.request(.lastBlock(server: self.server)) { (result) in
            switch result {
            case .success(let response):
                    guard let responseValue:[String: Any] = (try! response.mapJSON() as? [String: Any]),let blockNumerHash = responseValue["result"] as? String, let value = BigInt(blockNumerHash.drop0x, radix: 16) else{
                        self.chainStateCompletion?(false, 0)
                        return
                    }
                    self.latestBlock =  numericCast(value)
                    self.chainStateCompletion?(true, numericCast(value))
            case .failure(_):
                self.chainStateCompletion?(false, 0)
            }
        }
    }
    
    private func getGasPrice() {
        provider.request(.getGasPrice(server: self.server)) { (result) in
            switch result {
            case .success(let response):
                guard let responseValue:[String: Any] = (try! response.mapJSON() as? [String: Any]),let blockNumerHash = responseValue["result"] as? String, let value = BigInt(blockNumerHash.drop0x, radix: 16) else{
                    return
                }
                self.gasPrice = value
            case .failure(_):
                break
            }
        }
    }
    
    func confirmations(fromBlock: Int) -> Int? {
        guard fromBlock > 0 else { return nil }
        let block = latestBlock - fromBlock
        guard latestBlock != 0, block >= 0 else { return nil }
        return max(1, block)
    }

}
