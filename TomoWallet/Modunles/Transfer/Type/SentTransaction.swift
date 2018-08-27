//
//  SentTransaction.swift
//  TomoWallet
//
//  Created by TomoChain on 8/27/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore

struct SentTransaction {
    let id: String
    let original: SignTransaction
    let data: Data
}

extension SentTransaction {
    static func from(transaction: SentTransaction) -> Transaction {
        return Transaction(
            id: transaction.id,
            blockNumber: 0,
            from: transaction.original.account.address.description,
            to: transaction.original.to?.description ?? "",
            value: transaction.original.value.description,
            gas: transaction.original.gasLimit.description,
            gasPrice: transaction.original.gasPrice.description,
            gasUsed: "",
            nonce: Int(transaction.original.nonce),
            date: Date(),
            coin: transaction.original.account.coin!,
            localizedOperations: [transaction.original.localizedObject].compactMap { $0 },
            state: .pending
        )
    }
}

