//
//  Pair.swift
//  TomoWallet
//
//  Created by TomoChain on 8/24/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import UIKit

struct Pair {
    let left: String
    let right: String
    func swapPair() -> Pair {
        return Pair(left: right, right: left)
    }
}

