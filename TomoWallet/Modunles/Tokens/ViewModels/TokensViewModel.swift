//
//  TokenViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import RealmSwift
import TrustCore
import PromiseKit
import TrustKeystore
protocol TokenViewModel_Delegate {
    func refresh()
}

final class TokensViewModel: NSObject{
    let config: Config
    
    let store: TokensDataStore
    var tokensNetwork: NetworkProtocol
    let tokens: Results<TokenObject>
    var tokensObserver: NotificationToken?
    let transactionStore: TransactionsStorage
    let session: WalletSession
    init(
        session: WalletSession,
        config: Config = Config(),
        store: TokensDataStore,
        tokensNetwork: NetworkProtocol,
        transactionStore: TransactionsStorage
        ) {
        self.session = session
        self.config = config
        self.store = store
        self.tokensNetwork = tokensNetwork
        self.tokens = store.tokens
        self.transactionStore = transactionStore
        super.init()
    }
    // public Function
    func fetch() {
        
        print(tokens.count)
        self.tokensInfo()

    }
    
    // private func
    
    
    //refesh tokens from ServerAPI
    private func tokensInfo() {
        firstly {
            tokensNetwork.tokensList()
        }.done { [weak self] tokens in
            self?.store.update(tokens: tokens, action: .updateInfo)
        }.catch { error in
            print("tokensInfo \(error)")
        }.finally { [weak self] in
            guard let strongSelf = self else { return }
            let tokens = Array(strongSelf.store.tokensBalance)
            strongSelf.prices(for: tokens)
        }
    }
    private func prices(for tokens: [TokenObject]) {
        let prices = tokens.map { TokenPrice(contract: $0.contract, symbol: $0.symbol) }
        firstly {
            tokensNetwork.tickers(with: prices)
            }.done { [weak self] tickers in
                guard let strongSelf = self else { return }
//                strongSelf.store.saveTickers(tickers: tickers)
            }.catch { error in
                NSLog("prices \(error)")
            }.finally { [weak self] in
                guard let strongSelf = self else { return }
//                strongSelf.balances(for: tokens)
        }
    }
//    private func balances(for tokens: [TokenObject]) {
//        let balances: [BalanceNetworkProvider] = tokens.compactMap {
//            return TokenViewModel.balance(for: $0, wallet: session.account)
//        }
//        let operationQueue: OperationQueue = OperationQueue()
//        operationQueue.qualityOfService = .background
//
//        let balancesOperations = Array(balances.lazy.map {
//            TokenBalanceOperation(balanceProvider: $0, store: self.store)
//        })
//
//        operationQueue.operations.onFinish { [weak self] in
//            DispatchQueue.main.async {
//                self?.delegate?.refresh()
//            }
//        }
//
//        operationQueue.addOperations(balancesOperations, waitUntilFinished: false)
//    }

}
