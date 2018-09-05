//
//  GasViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 9/5/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import BigInt
struct GasViewModel {
    let fee: BigInt
    let server: RPCServer
    let store: TokensDataStore
    let formatter: EtherNumberFormatter
    init(fee: BigInt, server: RPCServer, store: TokensDataStore, formatter: EtherNumberFormatter) {
        self.fee = fee
        self.server = server
        self.store = store
        self.formatter = formatter
    }

    var etherFee: String {
        let gasFee = formatter.string(from: fee)
        return "\(gasFee.description) \(server.symbol)"
    }
    
    var feeCurrency: Double? {
        guard let price = store.coinTicker(by: server.priceID)?.price else {
            return .none
        }
        return FeeCalculator.estimate(fee: formatter.string(from: fee), with: price)
    }
    
    var monetaryFee: String? {
        guard let feeInCurrency = feeCurrency,
            let fee = FeeCalculator.format(fee: feeInCurrency) else {
                return .none
        }
        return fee
    }
    
    
    var feeText: String {
        var text = etherFee
        if let monetaryFee = monetaryFee {
            text += "(\(monetaryFee))"
        }
        return text
    }
    
}
