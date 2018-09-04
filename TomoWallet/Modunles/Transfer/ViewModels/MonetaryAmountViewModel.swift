//
//  MonetaryAmountViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 9/4/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import BigInt
import TrustCore

struct MonetaryAmountViewModel {
    let amount: String
    let contract: Address
    let session: WalletSession
    let formatter: EtherNumberFormatter
    init(amount: String, contract: Address, session: WalletSession, formatter: EtherNumberFormatter) {
        self.amount = amount
        self.contract = contract
        self.session = session
        self.formatter = formatter
    }
    
    var amountCurrency: Double?{
        guard let price = session.tokensStorage.coinTicker(by: contract)?.price else{
            return .none
        }
        return FeeCalculator.estimate(fee: amount, with: price)
    }
    
    var amountText: String? {
        guard let amountCurrency = amountCurrency,
            let result = FeeCalculator.format(fee: amountCurrency) else {
                return .none
        }
        return "(\(result))"
    }
}

