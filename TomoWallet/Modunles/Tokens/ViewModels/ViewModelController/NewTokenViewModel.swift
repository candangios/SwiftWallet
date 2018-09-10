//
//  NewTokenViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 9/4/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import PromiseKit
import TrustCore
import TrustKeystore

struct NewTokenViewModel {
    let token: ERC20Token?
    let session: WalletSession
    let tokenNetWork: NetworkProtocol
    
    private var rpcNetwork: ContractNetworkProvider{
        let RPCServer = self.session.currentRPC
        return ContractNetworkProvider(server:RPCServer, provider: ApiProviderFactory.makeRPCNetworkProvider())
    }
    init(token: ERC20Token?, session: WalletSession, tokenNetwork: NetworkProtocol) {
        self.token = token
        self.session = session
        self.tokenNetWork = tokenNetwork
    }
    
    var title: String{
        return "Add custom token"
    }
    var coin: Coin{
        return self.session.account.coin!
    }
    
  
    
//    func info(for contract: EthereumAddress)  {
//
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        dispatchGroup.notify(queue: .main) {
//            print("Both functions complete 👍")
//        }
//        print(rpcNetwork)
//        let a =  rpcNetwork.name(contracsAddress: contract)
//        let b = rpcNetwork.decimals(contracsAddress: contract)
//        let c = rpcNetwork.symbol(contracsAddress: contract)
//
//
//
//
//    }
    
    
    
    func info(for contract: String) -> Promise<TokenObject> {
        return Promise { seal in
            firstly {
                tokenNetWork.search(query: contract).firstValue
                }.done { token in
                    seal.fulfill(token)
                }.catch { error in
                    seal.reject(error)
            }
        }
    }
    
    

}
