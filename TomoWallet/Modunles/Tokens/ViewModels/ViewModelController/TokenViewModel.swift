//
//  TokenViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 8/23/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation

import TrustKeystore
import TrustCore
import Result
import BigInt
import RealmSwift
protocol TokenViewModel_Delegate {
    
}

final class TokenViewModel{
    private let shortFormatter = EtherNumberFormatter.short
    private let config: Config
    private let store: TokensDataStore
    private let session: WalletSession
    private var tokensNetwork: NetworkProtocol
    private let transactionsStore: TransactionsStorage
    private var tokenTransactions: Results<Transaction>?
    private var tokenTransactionSections: [TransactionSection] = []
    
    // observe when change object in realm
    private var notificationToken: NotificationToken?
    private var transactionToken: NotificationToken?
    
    let token: TokenObject
    private lazy var tokenObjectViewModel: TokenObjectViewModel = {
        return TokenObjectViewModel(token: token)
    }()
    
    var name: String {
        return tokenObjectViewModel.name
    }
    var symbol: String {
        return tokenObjectViewModel.symbol
    }
    
    var imageURL: URL? {
        return tokenObjectViewModel.imageURL
    }
    
    var imagePlaceholder: UIImage? {
        return tokenObjectViewModel.placeholder
    }
    
    
    var amountFont: UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    

    let backgroundColor: UIColor = {
        return .white
    }()
    
//    lazy var transactionsProvider: EthereumTransactionsProvider = {
//        return EthereumTransactionsProvider(server: server)
//    }()
    
    var amount: String {
        return String(
            format: "%@",
            shortFormatter.string(from: BigInt(token.value) ?? BigInt(), decimals: token.decimals)
        )
    }
    
    var numberOfSections: Int {
        return tokenTransactionSections.count
    }
    
    var server: RPCServer {
        
        // can Rem
        return token.coin.server
//        return TokensDataStore.getServer(for: token)
    }
    
    lazy var currentAccount: Account = {
        return session.account.accounts.filter { $0.coin == token.coin }.first!
    }()
    init(
        token: TokenObject,
        config: Config = Config(),
        store: TokensDataStore,
        transactionsStore: TransactionsStorage,
        tokensNetwork: NetworkProtocol,
        session: WalletSession
        ) {
        self.token = token
        self.transactionsStore =  transactionsStore
        self.config = config
        self.store = store
        self.tokensNetwork = tokensNetwork
        self.session = session
        prepareDataSource(for: token)
    }
    
    var ticker: CoinTicker? {
        return store.coinTicker(by: token.address)
    }
    
    var allTransactions: [Transaction] {
        return Array(tokenTransactions!)
    }

    
    var pendingTransactions: [Transaction] {
        return Array(tokenTransactions!.filter { $0.state == TransactionState.pending })
    }
    

    func fetch() {
        updateTokenBalance()
        fetchTransactions()
//        updatePending()
    }
    
    func tokenObservation(with completion: @escaping (() -> Void)) {
        notificationToken = token.observe { change in
            switch change {
            case .change, .deleted, .error:
                completion()
            }
        }
    }
    
    func transactionObservation(with completion: @escaping (() -> Void)) {
        transactionToken = tokenTransactions?.observe { _ in
            // do something when refesh transaction completed
            completion()
        }
    }
    
    private func updateTokenBalance() {
        guard let provider = TokenViewModel.balance(for: token, wallet: session.account) else {
            return
        }
        let _ = provider.balance().done { [weak self] balance in
            self?.store.update(balance: balance, for: provider.addressUpdate)
        }
    }
    
    static func balance(for token: TokenObject, wallet: WalletInfo) -> BalanceNetworkProvider? {
        let first = wallet.accounts.filter { $0.coin == token.coin }.first
        guard let account = first else { return .none }
        let networkBalance: BalanceNetworkProvider? = {
            switch token.type {
            case .coin:
                return CoinNetworkProvider(
                    server: token.coin.server,
                    address: EthereumAddress(string: account.address.description)!,
                    addressUpdate: token.address,
                    provider: ApiProviderFactory.makeRPCNetworkProvider()
                )
            case .ERC20:
                return TokenNetworkProvider(
                    server: token.coin.server,
                    address: EthereumAddress(string: account.address.description)!,
                    contract: token.address,
                    addressUpdate: token.address,
                    provider: ApiProviderFactory.makeRPCNetworkProvider()
                )
            }
        }()
        return networkBalance
    }
    
//    func updatePending() {
//        let transactions = pendingTransactions
//
//        for transaction in transactions {
//            transactionsProvider.update(for: transaction) { result in
//                switch result {
//                case .success(let transaction, let state):
//                    self.transactionsStore.update(state: state, for: transaction)
//                case .failure: break
//                }
//            }
//        }
//    }
    
    private func fetchTransactions() {
        let contract: String? = {
            switch token.type {
            case .coin: return .none
            case .ERC20: return token.contract
            }
        }()
        tokensNetwork.transactions(for: currentAccount.address, on: server, startBlock: 1, page: 0, contract: contract) { result in
            guard let transactions = result.0 else { return }
            // add direction for transaction
            self.transactionsStore.add(transactions)
        }
    }
    
    private func prepareDataSource(for token: TokenObject) {
        switch token.type {
        case .coin:
            tokenTransactions = transactionsStore.realm.objects(Transaction.self)
                .filter(NSPredicate(format: "rawCoin = %d", server.coin.rawValue))
                .sorted(byKeyPath: "date", ascending: false)
        case .ERC20:
            tokenTransactions = transactionsStore.realm.objects(Transaction.self)
                .filter(NSPredicate(format: "rawCoin = %d && %K ==[cd] %@", server.coin.rawValue, "to", token.contract))
                .sorted(byKeyPath: "date", ascending: false)
        }
    }
    

    
    func createTransactionsPageView(type: TransactionsPageViewType) -> TransactionsPageView {
        return TransactionsPageView(type: type, config: config, currentAccount: currentAccount, transactionsStore: transactionsStore, token: token, tokenTransactions: tokenTransactions!)
    }
    
    func invalidateObservers() {
        notificationToken?.invalidate()
        notificationToken = nil
        transactionToken?.invalidate()
        transactionToken = nil
    }
    
    
}
