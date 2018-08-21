//
//  ArrayResponse.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
struct ArrayResponse<T: Decodable>: Decodable {
    let docs: [T]
}

