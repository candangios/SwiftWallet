//
//  ConfirmPaymentDetailViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 9/4/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import BigInt
struct ConfrimPaymentDetailViewModel {
    let transaction: PreviewTransaction
    let session: WalletSession
    let config: Config
    let server: RPCServer
    private let fullFormatter = EtherNumberFormatter.full
    private let balanceFormatter = EtherNumberFormatter.balance
    private var gasViewModel: GasViewModel {
        return GasViewModel(fee: totalFee, server: server, store: session.tokensStorage, formatter: fullFormatter)
    }
    init(
        transaction: PreviewTransaction,
        config: Config = Config(),
        session: WalletSession,
        server: RPCServer
        ) {
        self.transaction = transaction
        self.config = config
        self.session = session
        self.server = server
    }
    
    private var totalFee: BigInt {
        return transaction.gasPrice * transaction.gasLimit
    }
    var toaddress:String{
        return (self.transaction.address?.description)!
    }
    
    var amount: String {
        switch transaction.transfer.type {
        case .token(let token):
            return balanceFormatter.string(from: transaction.value, decimals: token.decimals)
        case .ether(let token, _):
            return balanceFormatter.string(from: transaction.value, decimals: token.decimals)
        }
    }
    var amountSymbol: String{
        return transaction.transfer.type.symbol(server: server)
    }
    
    var estimatedFee: String{
        let unit = UnitConfiguration.gasFeeUnit
        return fullFormatter.string(from: totalFee, units: unit)
    }
    var symbolFee: String{
        return server.symbol
    
    }

    
    
    
  

}

