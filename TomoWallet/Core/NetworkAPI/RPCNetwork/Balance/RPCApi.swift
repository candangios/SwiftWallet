//
//  RPCApi.swift
//  TomoWallet
//
//  Created by TomoChain on 8/21/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import Foundation
import TrustCore
import Moya
enum RPCApi{
    case getBalanceCoin(server: RPCServer, address: String)
    case getBalanceToken(server: RPCServer, contract: String, data: String)

}
extension RPCApi: TargetType{

    var baseURL: URL{
        switch self {
        case .getBalanceCoin(let server,_):
            print(server.rpcURL)
            return  server.rpcURL
        case .getBalanceToken(let server,_,_):
            print(server.rpcURL)
            return  server.rpcURL
        }
    
    }

    var path: String {
        switch self {
        case .getBalanceCoin:
            return ""
        case .getBalanceToken:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBalanceCoin: return .post
        case .getBalanceToken: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getBalanceCoin:
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_getBalance",
                "params": ["0xc94770007dda54cF92009BFF0dE90c06F603a09f", "latest"],
                "id": 1
                ] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getBalanceToken:
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_call",
                "params": [
                    [
                        "to": "0x2022341Ee7097dB05C0845D4eaF660c77e42A89a",
                        "data": "0x70a082310000000000000000000000006e7312d1028b70771bb9cdd9837442230a9349ca"
                    ],
                    "latest"
                ],
                "id": 1
                ] as [String : Any]
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    
        }
 
//        return .requestData(sampleData)
    }
    
    var sampleData: Data {
        return Data()
  
    }
    
    var headers: [String: String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
