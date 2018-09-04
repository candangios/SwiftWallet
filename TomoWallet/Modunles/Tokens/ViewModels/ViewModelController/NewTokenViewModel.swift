//
//  NewTokenViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 9/4/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import PromiseKit

struct NewTokenViewModel {
    let token: ERC20Token?
    let session: WalletSession
    let tokenNetWork: NetworkProtocol
    init(token: ERC20Token?, session: WalletSession, tokenNetwork: NetworkProtocol) {
        self.token = token
        self.session = session
        self.tokenNetWork = tokenNetwork
    }
    
    var title: String{
        return "Add custom token"
    }
    
    var contrac: String{
        return token?.contract.description ?? ""
    }
    
    var name: String{
        return token?.name ?? ""
    }
    
    var symbol: String {
        return token?.symbol ?? ""
    }
    
    var decimals: String {
        guard let decimals = token?.decimals else { return "" }
        return "\(decimals)"
    }
    
    var networkSelectorAvailable: Bool {
        return networks.count > 1
    }
    
    var network: RPCServer {
        guard let server = token?.coin.server else {
            if networkSelectorAvailable {
                return .main
            }
            return session.account.currentAccount.coin?.server ?? .main
        }
        return server
    }
    
    var networks: [RPCServer] {
        return session.account.accounts.compactMap { $0.coin?.server }
    }
    
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
