//
//  ReveiceViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 8/28/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
final class ReveiceVideModel{
    let coinTypeViewModel: CoinTypeViewModel
    init(coinTypeViewModel: CoinTypeViewModel) {
        self.coinTypeViewModel = coinTypeViewModel
    }
    var title: String{
        return coinTypeViewModel.name
    }
    var address: String{
        return coinTypeViewModel.address
    }
    
    
}
