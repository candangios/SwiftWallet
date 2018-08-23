//
//  Transfer.swift
//  TomoWallet
//
//  Created by TomoChain on 8/23/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore

struct Transfer {
    let server: RPCServer
    let type: TransferType
}
enum TransferType {
    case ether(TokenObject, destination: EthereumAddress?)
    case token(TokenObject)
}
extension TransferType {
    func symbol(server: RPCServer) -> String {
        switch self {
        case .ether:
            return server.symbol
        case .token(let token):
            return token.symbol
        }
    }
    
    //used for pricing
    var contract: String {
        switch self {
        case .ether(let token, _):
            return token.contract
        case .token(let token):
            return token.contract
        }
    }
    
    var token: TokenObject {
        switch self {
        case .ether(let token, _):
            return token
        case .token(let token):
            return token
        }
    }
    
    var address: EthereumAddress {
        switch self {
        case .ether(let token, _):
            return token.address
        case .token(let token):
            return token.address
        }
    }
}


