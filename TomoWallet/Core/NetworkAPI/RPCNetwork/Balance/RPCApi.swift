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
        case .getBalanceCoin(let rpcServer,_):
            print(rpcServer.rpcURL.absoluteString)
            return  rpcServer.rpcURL
        case .getBalanceToken(let rpcServer, let address,let  contract):
            return  rpcServer.rpcURL
        }
    
    }

    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        switch self {
        case .getBalanceCoin: return .get
        case .getBalanceToken: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getBalanceCoin(_ , let address):
            let params: [String: Any] = ["jsonrpc": "2.0", "method": "eth_getBalance", "paparams": "[\"\(address)\",\"latest\"]","id":1]
            return .requestParameters(parameters: params, encoding: URLEncoding())
        case .getBalanceToken(_, let address,let  contractAddress):
            return .requestJSONEncodable(address)
        }

    }
    
    var sampleData: Data {
        
//        switch self {
//        case .getBalanceCoin(_, let address):
//             let a = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\": [\"\(address)\", \"latest\"],\"id\":1}"
//             return a.data(using: .utf8)!
//        default:
            return Data()
//        }
  
    }
    
    var headers: [String: String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
