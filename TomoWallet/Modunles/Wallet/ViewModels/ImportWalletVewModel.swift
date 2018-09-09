//
//  ImportWalletVewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 9/9/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore

struct ImportWalletViewModel {
    
    private let coin: CoinViewModel
    
    init(
        coin: Coin
        ) {
        self.coin = CoinViewModel(coin: coin)
    }
    
    var title: String {
        return  "Import " + coin.name
    }
    
    
   
}

