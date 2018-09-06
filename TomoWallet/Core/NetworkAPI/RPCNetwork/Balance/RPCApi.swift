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
    case lastBlock(server: RPCServer)
    case getGasPrice(server: RPCServer)
    case estimateGasLimit(server: RPCServer, transaction: SignTransaction)
    case sendRawTransaction(server: RPCServer, signedTransaction: String )
    case getTransactionCount(server: RPCServer, address: String)
    
}
extension RPCApi: TargetType{

    var baseURL: URL{
        switch self {
        case .getBalanceCoin(let server,_):
            return  server.rpcURL
        case .getBalanceToken(let server,_,_):
            return  server.rpcURL
        case .lastBlock(let server):
            return  server.rpcURL
        case .getGasPrice(let server):
            return  server.rpcURL
        case .estimateGasLimit(let server,_):
            return server.rpcURL
        case .sendRawTransaction(let server,_):
            return server.rpcURL
        case .getTransactionCount(let server,_):
            return server.rpcURL
        }
       
    }

    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        switch self {
        case .getBalanceCoin: return .post
        case .getBalanceToken: return .post
        case .lastBlock: return .post
        case .getGasPrice: return.post
        case .estimateGasLimit: return .post
        case .sendRawTransaction: return .post
        case .getTransactionCount: return .post
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
        case .getBalanceToken(_, let contract, let data):
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_call",
                "params": [
                    [
                        "to": "\(contract)",
                        "data": "\(data)"
                    ],
                    "latest"
                ],
                "id": 1
                ] as [String : Any]
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .lastBlock:
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_blockNumber",
                "id": 1
                ] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getGasPrice:
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_gasPrice",
                "id": 1
                ] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .estimateGasLimit(_, let transaction):
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_estimateGas",
                "params": [
                    [
                        "from": "\(transaction.account.address.description.lowercased())",
                        "to": "\(transaction.to?.description.lowercased() ?? "")",
                        "gasPrice": transaction.gasPrice.hexEncoded,
                        "value": transaction.value.hexEncoded,
                        "data": transaction.data.hexEncoded,
                    ]
                   
                ],
                "id": 1
                ] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .sendRawTransaction(_, let signedTransaction):
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_sendRawTransaction",
                "params": ["\(signedTransaction)"],
                "id": 1
                ] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getTransactionCount(_, let address):
            let parameters = [
                "jsonrpc": "2.0",
                "method": "eth_getTransactionCount",
                "params": ["\(address)", "latest"],
                "id": 1
                ] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
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
