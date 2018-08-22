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
protocol TokenViewModel_Delegate: class {
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
    
    lazy var network: NetworkProtocol = {
        return ApiNetwork(provider: ApiProviderFactory.makeProvider(), wallet: session.account)
    }()

    
    weak var delegate: TokenViewModel_Delegate?
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
        self.tokensInfo()
    }
    func cellViewModel(for path: IndexPath) -> TokenViewCellViewModel {
        let token = tokens[path.row]
        
        return TokenViewCellViewModel(
            viewModel: TokenObjectViewModel(token: token),
            ticker: store.coinTicker(by: token.address),
            store: transactionStore
        )
    }
    
    // private func
    
    
    //refesh tokens from ServerAPI
    private func tokensInfo() {
        firstly {
            tokensNetwork.tokensList()
        }.done { [weak self] tokens in
            print(tokens)
            guard let strongSelf = self else { return }
            strongSelf.store.update(tokens: tokens, action: .updateInfo)
        }.catch { error in
            print("tokensInfo \(error)")
        }.finally { [weak self] in
            guard let strongSelf = self else { return }
            let tokens = Array(strongSelf.store.tokensBalance)
            print(tokens)
            strongSelf.prices(for: tokens)
        }
    }
    private func prices(for tokens: [TokenObject]) {
        let prices = tokens.map { TokenPrice(contract: $0.contract, symbol: $0.symbol) }
        firstly {
            tokensNetwork.tickers(with: prices)
            }.done { [weak self] tickers in
                print(tickers)
                guard let strongSelf = self else { return }
                strongSelf.store.saveTickers(tickers: tickers)
            }.catch { error in
                NSLog("prices \(error)")
            }.finally { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.balances(for: tokens)
             
        }
    }
    private func balances(for tokens: [TokenObject]) {
        let account = session.account
        let balances: [BalanceNetworkProvider] = tokens.compactMap {
            let token = $0
            switch token.type{
            case .coin:
                return CoinNetworkProvider(server: token.coin.server, address: EthereumAddress(string: account.address.description)!, addressUpdate: token.address, provider: ApiProviderFactory.makeBalanceProvider())
            case.ERC20:
                return TokenNetworkProvider(server: token.coin.server, address: EthereumAddress(string: account.address.description)!, contract: token.address, addressUpdate: token.address, provider: ApiProviderFactory.makeBalanceProvider())

            }
//            return TokenViewModel.balance(for: $0, wallet: session.account)
        }
        let operationQueue: OperationQueue = OperationQueue()
        operationQueue.qualityOfService = .background

        let balancesOperations = Array(balances.lazy.map {
            TokenBalanceOperation(balanceProvider: $0, store: self.store)
        })

        operationQueue.operations.onFinish { [weak self] in
            DispatchQueue.main.async {
                self?.delegate?.refresh()
            }
        }
        operationQueue.addOperations(balancesOperations, waitUntilFinished: false)
    }
}
extension Array where Element: Operation {
    /// Execute block after all operations from the array.
    func onFinish(block: @escaping () -> Void) {
        let doneOperation = BlockOperation(block: block)
        self.forEach { [unowned doneOperation] in
            doneOperation.addDependency($0)
            
        }
        OperationQueue().addOperation(doneOperation)
    }
}