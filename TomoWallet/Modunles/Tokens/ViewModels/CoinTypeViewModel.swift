//
//  CoinTypeViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 8/28/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustKeystore
import TrustCore

enum CoinType{
    case coin(Account, TokenObject)
    case tokenOf(Account, TokenObject)
}
struct CoinTypeViewModel {
    let type: CoinType
    var account: Account {
        switch type {
        case .coin(let account, _):
            return account
        case .tokenOf(let account, _):
            return account
        }
    }
    
    var address: String {
        switch type {
        case .coin(let account, _):
            return account.address.description
        case .tokenOf(let account, _):
            return account.address.description
        }
    }
    
    var name: String {
        switch type {
        case .coin(_, let token):
            return token.name
        case .tokenOf(_, let token):
            return token.name
        }
    }
}
