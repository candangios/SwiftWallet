//
//  WalletInfoType.swift
//  TomoWallet
//
//  Created by TomoChain on 8/6/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustKeystore
import TrustCore
import UIKit

enum WalletInfoType{
    case exportRecoveryPhrase(Wallet)
    case exportPrivateKey(Account)
    case exportKeystore(Account)
    case copyAddress(Address)
    
    var title: String {
        switch self {
        case .exportRecoveryPhrase:
            return "Show Backup Phrase"
        case .exportPrivateKey:
            return "Export PrivateKey"
        case .exportKeystore:
            return "Backup Keystore"
        case .copyAddress:
            return "Copy Address"
        }
    }
    
    var image: UIImage? {
        
        // do something
        // Create icon image for Wallet type this here.
        return UIImage()
    }
}

// compare
extension WalletInfoType: Equatable {
    static func == (lhs: WalletInfoType, rhs: WalletInfoType) -> Bool {
        switch (lhs, rhs) {
        case (let .exportRecoveryPhrase(lhs), let .exportRecoveryPhrase(rhs)):
            return lhs == rhs
        case (let .exportKeystore(lhs), let .exportKeystore(rhs)):
            return lhs == rhs
        case (let .exportPrivateKey(lhs), let .exportPrivateKey(rhs)):
            return lhs == rhs
        case (let .copyAddress(lhs), let .copyAddress(rhs)):
            return lhs.data == rhs.data
        case (_, .exportRecoveryPhrase),
             (_, .exportKeystore),
             (_, .exportPrivateKey),
             (_, .copyAddress):
            return false
        }
    }
}

