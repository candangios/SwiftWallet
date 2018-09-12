//
//  API.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import Moya
enum API{
    case getTransactions(server: RPCServer, address: String, startBlock: Int, page: Int, contract: String?)
    case prices(TokensPrice)
    case getAllTransactions(addresse: String)
    case search(query: String, networks: [Int])
    case collectibles([String: [String]])
    case getTokens([String: [String]])
}
extension API: TargetType{
    var baseURL: URL { return Constants.TomoAPI }
    var path: String {
        switch self {
        case .prices:
            return "/prices"
        case .getTransactions:
            return "/transactions"
        case .getTokens:
            return "/tokens"
        case .getAllTransactions:
            return "/transactions"
        case .collectibles:
            return "/collectibles"
        case .search:
            return "/tokens/list"
        }
    }
    
    
    var method: Moya.Method {
        switch self {
        case .prices: return .post
        case .getTransactions: return .get
        case .getTokens: return .post
        case .getAllTransactions: return .get
        case .collectibles: return .post
        case .search: return .get
        }
    }
    var task: Task {
        switch self {
        case .prices(let tokensPrice):
            return .requestJSONEncodable(tokensPrice)
        case .getTransactions(_, let address, let startBlock, let page, let contract):
            var params: [String: Any] = ["address": address, "startBlock": startBlock, "page": page, "limit": 100]
            if let transactionContract = contract {
                params["contract"] = transactionContract
            }
            return .requestParameters(parameters: params, encoding: URLEncoding())
        case .getAllTransactions(let addresses):
            return .requestParameters(parameters: ["address": addresses], encoding: URLEncoding())

        case .collectibles(let value), .getTokens(let value):
            return .requestJSONEncodable(value)
        case .search(let query, let networks):
            let networkString =  networks.map { String($0) }.joined(separator: ",")
            return .requestParameters(parameters: ["query": query, "networks": networkString], encoding: URLEncoding())
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "client": Bundle.main.bundleIdentifier ?? "",
            "client-build": Bundle.main.buildNumber ?? "",
        ]
    }
}
