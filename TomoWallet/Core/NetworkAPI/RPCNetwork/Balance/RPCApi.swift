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
        case .getBalanceCoin(_,let address):
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_getBalance",
                "params": ["\(address)", "latest"],
                "id": 1
                ] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getBalanceToken(_, let contrac, let data):
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_call",
                "params": [
                    [
                        "to": "\(contrac)",
                        "data": "\(data)"
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
