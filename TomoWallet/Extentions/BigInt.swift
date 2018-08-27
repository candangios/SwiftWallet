//
//  BigInt.swift
//  TomoWallet
//
//  Created by TomoChain on 8/27/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import BigInt
extension BigInt{
    var hexEncoded: String {
        return "0x" + String(self, radix: 16)
    }
}
