//
//  ImportType.swift
//  TomoWallet
//
//  Created by TomoChain on 8/8/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore
enum ImportType {
    case keystore (string: String, password: String)
    case privatekey (privatekey: String)
    case mnemonic (words: [String], password: String, derivationPath: DerivationPath)
    case address (address: EthereumAddress)
}
