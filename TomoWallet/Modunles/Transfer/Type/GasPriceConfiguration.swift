//
//  GasPriceConfiguration.swift
//  TomoWallet
//
//  Created by TomoChain on 8/27/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import BigInt

public struct UnitConfiguration {
    public static let gasPriceUnit: EthereumUnit = .gwei
    public static let gasFeeUnit: EthereumUnit = .ether
}

public struct GasPriceConfiguration {
    static let `default`: BigInt = EtherNumberFormatter.full.number(from: "24", units: UnitConfiguration.gasPriceUnit)!
    static let min: BigInt = EtherNumberFormatter.full.number(from: "1", units: UnitConfiguration.gasPriceUnit)!
    static let max: BigInt = EtherNumberFormatter.full.number(from: "100", units: UnitConfiguration.gasPriceUnit)!
}
