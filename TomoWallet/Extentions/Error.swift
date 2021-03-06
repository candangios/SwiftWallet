//
//  Error.swift
//  TomoWallet
//
//  Created by TomoChain on 8/16/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import Result

extension Error {
    var prettyError: String {
        switch self {
        case let error as AnyError:
//            switch error.error {
//            case let error as APIKit.SessionTaskError:
//                switch error {
//                case .connectionError(let error):
//                    return error.localizedDescription
//                case .requestError(let error):
//                    return error.localizedDescription
//                case .responseError(let error):
//                    guard let JSONError = error as? JSONRPCError else {
//                        return error.localizedDescription
//                    }
//                    switch JSONError {
//                    case .responseError(_, let message, _):
//                        return message
//                    default: return "Undefined error"
//                    }
//                }
//            default:
                return error.errorDescription ?? error.description
//            }
        case let error as LocalizedError:
            if let keystoreError = error as? KeystoreError{
                return keystoreError.errorDescription
            }
            return error.errorDescription ?? "An unknown error occurred."
        case let error as NSError:
            return error.localizedDescription
        default:
            return "Undefined Error"
        }
    }
    
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
