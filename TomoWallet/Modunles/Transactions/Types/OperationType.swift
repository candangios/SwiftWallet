//
//  File.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
enum OperationType: String {
    case tokenTransfer = "token_transfer"
    case unknown
    
    init(string: String) {
        self = OperationType(rawValue: string) ?? .unknown
    }
}

extension OperationType: Decodable { }
