
// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore

enum RPCServer {
    case main
    case poa
    case classic
    case callisto
    case gochain
    case rinkebyTestnet
    case tomo
    
    var id: String {
        switch self {
        case .main: return "ethereum"
        case .poa: return "poa"
        case .classic: return "classic"
        case .callisto: return "callisto"
        case .gochain: return "gochain"
        case .rinkebyTestnet: return "rinkeby"
        case .tomo: return "tomo"
        }
    }
    
    var chainID: Int {
        switch self {
        case .main: return 1
        case .poa: return 99
        case .classic: return 61
        case .callisto: return 820
        case .gochain: return 60
        case .rinkebyTestnet: return 4
        case .tomo:return 40686
        }
    }
    
    var priceID: Address {
        switch self {
        case .main: return EthereumAddress(string: "0x000000000000000000000000000000000000003c")!
        case .poa: return EthereumAddress(string: "0x00000000000000000000000000000000000000AC")!
        case .classic: return EthereumAddress(string: "0x000000000000000000000000000000000000003D")!
        case .callisto: return EthereumAddress(string: "0x0000000000000000000000000000000000000334")!
        case .gochain: return EthereumAddress(string: "0x00000000000000000000000000000000000017aC")!
        case .rinkebyTestnet: return EthereumAddress(string: "0x000000000000000000000000000000000000003c")!
        case .tomo:
            return EthereumAddress(string: "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")!
        }
    }
    
    var isDisabledByDefault: Bool {
        switch self {
        case .main, .rinkebyTestnet, .tomo: return false
        case .poa, .classic, .callisto, .gochain: return true
        }
    }
    
    var name: String {
        switch self {
        case .main: return "Ethereum"
        case .poa: return "POA Network"
        case .classic: return "Ethereum Classic"
        case .callisto: return "Callisto"
        case .gochain: return "GoChain"
        case .rinkebyTestnet: return "RinkebyTestnet"
        case .tomo:
            return "Tomo"
        }
    }
    
    var displayName: String {
        return "\(self.name) (\(self.symbol))"
    }
    
    var symbol: String {
        switch self {
        case .main: return "ETH"
        case .classic: return "ETC"
        case .callisto: return "CLO"
        case .poa: return "POA"
        case .gochain: return "GO"
        case .rinkebyTestnet: return "ETH"
        case .tomo:
            return "TOMO"
        }
    }
    
    var decimals: Int {
        return 18
    }
    
    var rpcURL: URL {
        let urlString: String = {
            switch self {
            case .main: return "https://mainnet.infura.io/v3/a78f819911994678934d1c811f3c4b47"
            case .classic: return "https://web3.gastracker.io"
            case .callisto: return "https://clo-geth.0xinfra.com"
            case .poa: return "https://poa.infura.io"
            case .gochain: return "https://rpc.gochain.io"
            case .rinkebyTestnet: return "https://rinkeby.infura.io/v3/a78f819911994678934d1c811f3c4b47"
            case .tomo:
                return "https://core.tomocoin.io"
            }
        }()
        return URL(string: urlString)!
    }
 
    var coin: Coin {
        switch self {
        case .main, .tomo: return Coin.ethereum
        case .classic: return Coin.ethereumClassic
        case .callisto: return Coin.callisto
        case .poa: return Coin.poa
        case .gochain: return Coin.gochain
        case .rinkebyTestnet:
            return Coin.rinkeby
        }
      
    }
}

extension RPCServer: Equatable {
    static func == (lhs: RPCServer, rhs: RPCServer) -> Bool {
        switch (lhs, rhs) {
        case (let lhs, let rhs):
            return lhs.chainID == rhs.chainID
        }
    }
}
