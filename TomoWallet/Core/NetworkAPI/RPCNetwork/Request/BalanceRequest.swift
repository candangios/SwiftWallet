//
//  BalanceRequest.swift
//  TomoWallet
//
//  Created by TomoChain on 8/20/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import JSONRPCKit
import BigInt
struct BalanceRequest: JSONRPCKit.Request {
    typealias Response = Balance
    
    let address: String
    
    var method: String {
        return "eth_getBalance"
    }
    
    var parameters: Any? {
        return [address, "latest"]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String, let value = BigInt(response.drop0x, radix: 16) {
            return Balance(value: value)
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
