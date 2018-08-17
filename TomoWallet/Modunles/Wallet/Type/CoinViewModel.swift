//
//  CoinViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore

struct CoinViewModel {
    
    let coin: Coin
    
    var displayName: String {
        return "\(name) (\(symbol))"
    }
    
    var name: String {
        switch coin {
        case .bitcoin: return "Bitcoin"
        case .ethereum: return "Ethereum"
        case .ethereumClassic: return "Ethereum Classic"
        case .poa: return "POA Network"
        case .callisto: return "Callisto"
        case .gochain: return "GoChain"
        case .rinkeby: return "RinkebyTestnet"
        }
    }
    
    var symbol: String {
        switch coin {
        case .ethereum: return "ETH"
        case .ethereumClassic: return "ETC"
        case .callisto: return "CLO"
        case .poa: return "POA"
        case .gochain: return "GO"
        case .bitcoin: return "Bitcoin"
        case .rinkeby: return "ETH"
        }
    }
    
    var image: UIImage? {
        switch coin {
        case .bitcoin: return .none
        case .ethereum: return .none
        case .ethereumClassic: return .none
        case .poa: return .none
        case .callisto: return .none
        case .gochain: return .none
        case .rinkeby:
            return .none
        }
    }
    
    var walletName: String {
        return name + " Wallet"
    }
}
