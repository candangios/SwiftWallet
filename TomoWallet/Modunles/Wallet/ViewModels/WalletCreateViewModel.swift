//
//  File.swift
//  TomoWallet
//
//  Created by TomoChain on 8/9/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//
enum WalletDoneType {
    case created
    case imported
    var title: String {
        switch self {
        case .created: return "Wallet Create"
        case .imported: return "Wallet Imported"
        }
    }
}

import Foundation
struct WalletCreateViewModel {
    let wallet: WalletInfo
    let type: WalletType
    
    var title: String {
        return wallet.info.name
    }
    var description: String{
        if wallet.multiWallet {
            return "Multi Coin Wallet"
        }
        return wallet.address.description
        
    }
}
