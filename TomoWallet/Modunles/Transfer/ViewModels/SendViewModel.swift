//
//  SendViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 8/24/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore
import BigInt

struct SendViewModel {
    
    /// transferType of a `SendViewModel` to know if it is token or ETH.
    let transfer: Transfer
    init(transfer: Transfer){
        self.transfer = transfer
    }

    /// stringFormatter of a `SendViewModel` to represent string values with respect of the curent locale.
    lazy var stringFormatter: StringFormatter = {
        return StringFormatter()
    }()

    var titile: String{
        return "Send \(symbol)"
    }
    var symbol: String {
        return transfer.type.token.symbol
    }
}
