//
//  TransactionPageViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 8/31/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustKeystore
import RealmSwift
final class TransactionsPageViewModel{
    private let shortFormatter = EtherNumberFormatter.short
    private let config: Config
    private let token: TokenObject
    private let currentAccount: Account
    private let transactionsStore: TransactionsStorage
    private var tokenTransactionSections: [TransactionSection] = []
    
    private var tokenTransactions: Results<Transaction>?

    let type: TransactionsPageViewType
    
    // observe when change object in realm
    private var transactionToken: NotificationToken?
    

    let titleFormmater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy"
        return formatter
    }()
    
    init(type: TransactionsPageViewType,
         config: Config,
         currentAccount:Account,
         transactionsStore: TransactionsStorage,
         token: TokenObject,
         tokenTransactions:Results<Transaction> )
    {
        self.type = type
        self.config = config
        self.token = token
        self.currentAccount = currentAccount
        self.transactionsStore = transactionsStore
        self.tokenTransactions = tokenTransactions
       
    }

    func transactionObservation(with completion: @escaping (() -> Void)) {
        transactionToken = tokenTransactions?.observe { [weak self] _ in
            self?.updateSections()
            completion()
        }
    }
    func updateSections()  {
        guard let tokens = tokenTransactions else { return }

        switch type {
        case .All:
             tokenTransactionSections = transactionsStore.mappedSections(for: Array(tokens))
        case .Sent:
          
            let filterTransactions  = Array(tokens).filter{$0.from == self.currentAccount.address.description || $0.from
                .lowercased() == self.currentAccount.address.description.lowercased()}

            tokenTransactionSections = transactionsStore.mappedSections(for: filterTransactions)
        case .Received:
    
             let filterTransactions  = Array(tokens).filter{$0.to == self.currentAccount.address.description || $0.to.lowercased() == self.currentAccount.address.description.lowercased()}
             
            tokenTransactionSections = transactionsStore.mappedSections(for: filterTransactions)
        }
   
    }
    
    var numberOfSections: Int {
        return tokenTransactionSections.count
    }
    
    func numberOfItems(for section: Int) -> Int {
        return tokenTransactionSections[section].items.count
    }
    
    func item(for row: Int, section: Int) -> Transaction {
        return tokenTransactionSections[section].items[row]
    }
    
    func convert(from title: String) -> Date? {
        return titleFormmater.date(from: title)
    }
    
    func titleForHeader(in section: Int) -> String {
        let stringDate = tokenTransactionSections[section].title
        guard let date = convert(from: stringDate) else {
            return stringDate
        }
        if NSCalendar.current.isDateInToday(date) {
            return "Today"
        }
        if NSCalendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        return stringDate
    }
    
    func cellViewModel(for indexPath: IndexPath) -> TransactionCellViewModel {
        
        return TransactionCellViewModel(
            transaction: tokenTransactionSections[indexPath.section].items[indexPath.row],
            config: config,
            currentAccount: currentAccount,
            server: token.coin.server,
            token: token,
            indexPatch: indexPath
        )
    }
    
    func hasContent() -> Bool {
        return !tokenTransactionSections.isEmpty
    }
    
}
