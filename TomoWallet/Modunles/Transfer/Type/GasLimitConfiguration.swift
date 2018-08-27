//
//  GasLimitConfigurator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/27/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import BigInt

public struct GasLimitConfiguration{
    static let `default` = BigInt(90_000)
    static let min = BigInt(21_000)
    static let max = BigInt(600_000)
    static let tokenTransfer = BigInt(144_000)
}
