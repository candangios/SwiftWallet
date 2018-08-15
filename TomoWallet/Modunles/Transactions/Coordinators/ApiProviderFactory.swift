//
//  ApiProviderFactory.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import Moya
import Alamofire
struct ApiProviderFactory {
    static let policies: [String: ServerTrustPolicy] = [
        :
      
    ]
    
    static func makeProvider() -> MoyaProvider<API> {
        let manager = Manager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies)
        )
        return MoyaProvider<API>(manager: manager)
    }
}
