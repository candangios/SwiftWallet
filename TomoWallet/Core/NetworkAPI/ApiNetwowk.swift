//
//  ApiNetwowk.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import PromiseKit
import Moya
import TrustCore
import TrustKeystore
import Result
import BigInt

import enum Result.Result

enum TrustNetworkProtocolError: LocalizedError {
    case missingContractInfo
}

protocol NetworkProtocol {
    func tickers(with tokenPrices: [TokenPrice]) -> Promise<[CoinTicker]>

    func tokensList() -> Promise<[TokenObject]>
    func transactions(for address: Address, on server: RPCServer, startBlock: Int, page: Int, contract: String?, completion: @escaping (_ result: ([Transaction]?, Error?)) -> Void)
    func search(query: String) -> Promise<[TokenObject]>
}

final class ApiNetwork: NetworkProtocol{
    let wallet: WalletInfo
    let provider: MoyaProvider<API>
    
    private var dict: [String: [String]] {
        var dict: [String: [String]] = [:]
        for account in wallet.accounts {
            dict["\(String(describing: account.coin!.rawValue))"] = [account.address.description]
        }
        return dict
    }
    private var networks: [Int] {
        return wallet.accounts.compactMap { $0.coin!.rawValue }
    }
    init(
        provider: MoyaProvider<API>,
        wallet: WalletInfo
        ) {
        self.provider = provider
        self.wallet = wallet
    }
    private func getTickerFrom(_ rawTicker: CoinTicker) -> CoinTicker? {
        guard let contract = EthereumAddress(string: rawTicker.contract) else { return .none }
        return CoinTicker(
            price: rawTicker.price,
            percent_change_24h: rawTicker.percent_change_24h,
            contract: contract,
            tickersKey: CoinTickerKeyMaker.makeCurrencyKey()
        )
    }
    
    // NetworkProtocol
    func tickers(with tokenPrices: [TokenPrice]) -> Promise<[CoinTicker]> {
        return Promise { seal in
            let tokensPriceToFetch = TokensPrice(
                currency: Config.current.currency.rawValue,
                tokens: tokenPrices
            )
            provider.request(.prices(tokensPriceToFetch)) { result in
                switch result {
                case .success(let response):
                    do {
                        let rawTickers = try response.map(ArrayResponse<CoinTicker>.self).docs
                        let tickers = rawTickers.compactMap { self.getTickerFrom($0) }
                        seal.fulfill(tickers)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
        
    }
    
    func tokensList() -> Promise<[TokenObject]> {
        return Promise { seal in
            provider.request(.getTokens(dict)) { result in
                switch result {
                case .success(let response):
                    do {
                        let items = try response.map(ArrayResponse<TokenObjectList>.self).docs
                        let tokens = items.map { $0.contract }
                        seal.fulfill(tokens)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func transactions(for address: Address, on server: RPCServer, startBlock: Int, page: Int, contract: String?, completion: @escaping (([Transaction]?, Error?)) -> Void) {
 
        provider.request(.getTransactions(server: server, address: address.description, startBlock: startBlock, page: page, contract: contract)) { result in
            switch result {
            case .success(let response):
                do {
                    let transactions = try JSONDecoder().decode([Transaction].self, from: response.data)
                    completion((transactions, nil))
                } catch {
                    completion((nil, error))
                }
            case .failure(let error):
                completion((nil, error))
            }
        }
    }
    
    func search(query: String) -> Promise<[TokenObject]> {
        return Promise { seal in
            provider.request(.search(query: query, networks: networks)) { result in
                switch result {
                case .success(let response):
                    do {
                        let tokens = try response.map(ArrayResponse<TokenObject>.self).docs
                        seal.fulfill(tokens)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

}




