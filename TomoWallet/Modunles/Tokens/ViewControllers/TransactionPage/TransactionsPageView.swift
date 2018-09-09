//
//  InstructionView.swift
//  TomoWallet
//
//  Created by TomoChain on 8/30/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import RealmSwift
import TrustKeystore

enum TransactionsPageViewType: Int {
    case All = 0
    case Received = 1
    case Sent = 2
}

final class TransactionsPageView: UITableViewController {
    private let config: Config
    private let token: TokenObject
    private let transactionsStore: TransactionsStorage
    private let tokenTransactions: Results<Transaction>
    private let currentAccount: Account
    
    var didselectedItem:((_ transaction:Transaction) -> Void)?
    
    let type: TransactionsPageViewType
    private lazy var viewModel: TransactionsPageViewModel = {
        return .init(type: type, config: config, currentAccount: currentAccount, transactionsStore: transactionsStore, token: token, tokenTransactions: tokenTransactions)
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
        super.init(style: .plain)
        self.tableView.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: TransactionViewCell.identifier, bundle: nil), forCellReuseIdentifier: TransactionViewCell.identifier)
        observTransactions()
    }
    
    private func observTransactions() {
        viewModel.transactionObservation { [weak self] in
            self?.tableView.reloadData()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfItems(for: section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionViewCell.identifier, for: indexPath) as! TransactionViewCell
        cell.configure(viewModel: viewModel.cellViewModel(for: indexPath))
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = viewModel.item(for: indexPath.row, section: indexPath.section)
        self.didselectedItem?(transaction)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = Bundle.main.loadNibNamed("SectionHeader", owner: self, options: nil)?.first as? SectionHeader  else {
            return .none
        }
        headerView.groupTitleLable.text = viewModel.titleForHeader(in: section)
        return headerView
    
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }


}
