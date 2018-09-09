//
//  TransactionViewCellViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 8/31/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import BigInt
import Foundation
import UIKit
import TrustKeystore
struct TransactionCellViewModel {
    
    private let transaction: Transaction
    private let config: Config
    private let currentAccount: Account
    private let token: TokenObject
    private let shortFormatter = EtherNumberFormatter.short
    private let transactionViewModel: TransactionViewModel
    private let indexPatch: IndexPath
    
    init(
        transaction: Transaction,
        config: Config,
        currentAccount: Account,
        server: RPCServer,
        token: TokenObject,
        indexPatch: IndexPath
        ) {
        self.transaction = transaction
        self.config = config
        self.currentAccount = currentAccount
        self.transactionViewModel = TransactionViewModel(
            transaction: transaction,
            config: config,
            currentAccount: currentAccount,
            server: server,
            token: token
        )
        self.token = token
        self.indexPatch = indexPatch
    }
    
    private var operationTitle: String? {
        guard let operation = transaction.operation else { return .none }
        switch operation.operationType {
        case .tokenTransfer:
            return String(
                format: NSLocalizedString(
                    "transaction.cell.tokenTransfer.title",
                    value: "Transfer %@",
                    comment: "Transfer token title. Example: Transfer OMG"
                ),
                operation.symbol ?? ""
            )
        case .unknown:
            return .none
        }
    }
    
    var subTitle: String {
        switch token.type {
        case .coin:
            return stateString
        case .ERC20:
            return operationTitle ?? stateString
        }
    }
    
    private var stateString: String {
        switch transaction.state {
        case .completed:
            switch transactionViewModel.direction {
            case .incoming:
                return NSLocalizedString("transaction.cell.received.title", value: "Received", comment: "")
            case .outgoing:
                return NSLocalizedString("transaction.cell.sent.title", value: "Sent", comment: "")
            }
        case .error:
            return NSLocalizedString("transaction.cell.error.title", value: "Error", comment: "")
        case .failed:
            return NSLocalizedString("transaction.cell.failed.title", value: "Failed", comment: "")
        case .unknown:
            return NSLocalizedString("transaction.cell.unknown.title", value: "Unknown", comment: "")
        case .pending:
            return NSLocalizedString("transaction.cell.pending.title", value: "Pending", comment: "")
        case .deleted:
            return ""
        }
    }
    
    var title: String {
        if transaction.toAddress == nil {
            return NSLocalizedString("transaction.deployContract.label.title", value: "Deploy smart contract", comment: "")
        }
        switch transactionViewModel.direction {
        case .incoming:
            return String(
                format: "%@: %@",
                NSLocalizedString("transaction.from.label.title", value: "From", comment: ""),
                transactionViewModel.transactionFrom
            )
        case .outgoing:
            return String(
                format: "%@: %@",
                NSLocalizedString("transaction.to.label.title", value: "To", comment: ""),
                transactionViewModel.transactionTo
            )
        }
    }
    
    var backgroundColor: UIColor {
        switch (indexPatch.row % 2) {
        case 1:
            return .white
        default:
            return UIColor(hex: "F8F8F8")
        }
    }

    var amountText: String {
        return transactionViewModel.amountText
    }


    var amountTextColor: UIColor {
        return transactionViewModel.amountTextColor
    }

    var statusImage: UIImage? {
        return transactionViewModel.statusImage
    }
}
