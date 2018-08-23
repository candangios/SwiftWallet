//
//  TokensDataStore.swift
//  TomoWallet
//
//  Created by TomoChain on 8/14/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import RealmSwift
import Result
import TrustCore
import BigInt
enum TokenAction {
    case disable(Bool)
    case updateInfo
}

class TokensDataStore {
    var tokens: Results<TokenObject> {
        return realm.objects(TokenObject.self).filter(NSPredicate(format: "isDisabled == NO"))
            .sorted(byKeyPath: "order", ascending: true)
    }
    let realm: Realm
    let account: WalletInfo
    
    init(account: WalletInfo, realm: Realm) {
        self.account = account
        self.realm = realm
        self.addNativeCoins()
    }
    
    func coinTicker(by contract: Address) -> CoinTicker? {
        return realm.object(ofType: CoinTicker.self, forPrimaryKey: CoinTickerKeyMaker.makePrimaryKey(contract: contract, currencyKey: CoinTickerKeyMaker.makeCurrencyKey()))
    }
    func addNativeCoins() {
        //check demoAccount
        if let token = self.getToken(for: EthereumAddress.zeroAddress){
            try? realm.write {
                realm.delete(token)
            }
        }
        
        let initialCoins = nativeCoin()
        
        for token in initialCoins {
            if let _ = getToken(for: token.contractAddress) {
            } else {
                add(tokens: [token])
            }
        }
    }
    
    func add(tokens: [Object]) {
        try? realm.write {
            if let tokenObjects = tokens as? [TokenObject] {
                let tokenObjectsWithBalance = tokenObjects.map { tokenObject -> TokenObject in
                    tokenObject.balance = self.getBalance(for: tokenObject.address, with: tokenObject.valueBigInt, and: tokenObject.decimals)
                    return tokenObject
                }
                realm.add(tokenObjectsWithBalance, update: true)
            } else {
                realm.add(tokens, update: true)
            }
        }
    }
    func getBalance(for address: Address, with value: BigInt, and decimals: Int) -> Double {
        guard let ticker = coinTicker(by: address),
            let amountInDecimal = EtherNumberFormatter.full.decimal(from: value, decimals: decimals),
            let price = Double(ticker.price) else {
                return TokenObject.DEFAULT_BALANCE
        }
        return amountInDecimal.doubleValue * price
    }
        
    
    func getToken(for address: Address) -> TokenObject? {
        return realm.object(ofType: TokenObject.self, forPrimaryKey: address.description)
    }
    
    
    private func nativeCoin() -> [TokenObject] {
        return account.accounts.compactMap { ac in
            let coin = ac.coin
           
            let viewModel = CoinViewModel(coin: coin!)
            let isDisabled: Bool = {
                if !account.mainWallet {
                    return false
                }
                return coin!.server.isDisabledByDefault
            }()
            
            return TokenObject(
                contract: (coin?.server.priceID.description)!,
                name: viewModel.name,
                coin: coin!,
                type: .coin,
                symbol: viewModel.symbol,
                decimals: (coin?.server.decimals)!,
                value: "0",
                isCustom: false,
                isDisabled: isDisabled,
                order: (coin?.rawValue)!
            )
        }
    }
    
    //Background update of the Realm model.
    // update Balance from infura
    func update(balance: BigInt, for address: Address) {
        if let token = getToken(for: address) {
            let tokenBalance = getBalance(for: token.address, with: balance, and: token.decimals)
            self.realm.writeAsync(obj: token) { (realm, _ ) in
                let update = self.objectToUpdate(for: (address, balance), tokenBalance: tokenBalance)
                realm.create(TokenObject.self, value: update, update: true)
            }
        }
    }
    private func objectToUpdate(for balance: (key: Address, value: BigInt), tokenBalance: Double) -> [String: Any] {
        return [
            "contract": balance.key.description,
            "value": balance.value.description,
            "balance": tokenBalance,
        ]
    }
    
    // update refesh from serverApi
    func update(tokens: [TokenObject], action: TokenAction) {
        try? realm.write {
            for token in tokens {
                switch action {
                case .disable(let value):
                    token.isDisabled = value
                case .updateInfo:
                    let update: [String: Any] = [
                        "contract": token.address.description,
                        "name": token.name,
                        "symbol": token.symbol,
                        "decimals": token.decimals,
                        "rawType": token.type.rawValue,
                        "rawCoin": token.coin.rawValue,
                        ]
                    realm.create(TokenObject.self, value: update, update: true)
                }
            }
        }
    }
    func saveTickers(tickers: [CoinTicker]) {
        guard !tickers.isEmpty else {
            return
        }
        try? realm.write {
            realm.add(tickers, update: true)
        }
    }
    
    var tokensBalance: Results<TokenObject> {
        return realm.objects(TokenObject.self).filter(NSPredicate(format: "isDisabled == NO || rawType = \"coin\""))
            .sorted(byKeyPath: "order", ascending: true)
    }
}

extension Coin {
    var server: RPCServer {
        switch self {
        case .bitcoin: return RPCServer.main //TODO
        case .ethereum: return RPCServer.main
        case .ethereumClassic: return RPCServer.classic
        case .gochain: return RPCServer.gochain
        case .callisto: return RPCServer.callisto
        case .poa: return RPCServer.poa
        case .rinkeby:
            return RPCServer.rinkebyTestnet
        }
    }
}
