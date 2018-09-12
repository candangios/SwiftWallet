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
                return "Received"
            case .outgoing:
                return "Sent"
            case .sendToYourself:
               return "Sent to yourself"
            }
        case .error:
            return "Error"
        case .failed:
            return "Failed"
        case .unknown:
            return "Unknown"
        case .pending:
            return "Pending"
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
                format: "From: %@",
                transactionViewModel.transactionFrom
            )
        case .outgoing:
            return String(
                format: "To: %@",
                transactionViewModel.transactionTo
            )
        case .sendToYourself:
            return "Sent to yourself"
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
