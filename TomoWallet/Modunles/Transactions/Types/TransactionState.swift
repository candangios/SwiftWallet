//
//  TransactionState.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
enum TransactionState: Int {
    case completed
    case pending
    case error
    case failed
    case unknown
    case deleted
    
    init(int: Int) {
        self = TransactionState(rawValue: int) ?? .unknown
    }
}

