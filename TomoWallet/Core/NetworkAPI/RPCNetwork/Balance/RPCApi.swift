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
    case getBalanceToken(server: RPCServer, address: String, contract: EthereumAddress )

}
extension RPCApi: TargetType{

    var baseURL: URL{
        switch self {
        case .getBalanceCoin(let server,_):
            return  server.rpcURL
        case .getBalanceToken(let server, let address,let  contract):
            return  server.rpcURL
        }
    
    }

    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        switch self {
        case .getBalanceCoin: return .post
        case .getBalanceToken: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getBalanceCoin:
            return .requestData(sampleData)
        case .getBalanceToken(_, let address,let  contractAddress):
            return .requestJSONEncodable(address)
        }

    }
    
    var sampleData: Data {
        
        switch self {
        case .getBalanceCoin(let address):
           
             let a = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\": [\"0xc94770007dda54cF92009BFF0dE90c06F603a09f\", \"latest\"],\"id\":1}"
             return a.data(using: .utf8)!
        default:
            return Data()
        }
  
    }
    
    var headers: [String: String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
