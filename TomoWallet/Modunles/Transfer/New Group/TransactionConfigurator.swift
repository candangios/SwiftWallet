//
//  TransactionConfigurator.swift
//  TomoWallet
//
//  Created by TomoChain on 8/27/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import BigInt
import Result
import TrustCore
import TrustKeystore
import Moya

struct PreviewTransaction{
    let value: BigInt
    let account: Account
    let address: EthereumAddress?
    let contract: EthereumAddress?
    let nonce: BigInt
    let data: Data
    let gasPrice: BigInt
    let gasLimit: BigInt
    let transfer: Transfer
}

final class TransactionConfigurator{
    let session: WalletSession
    let account: Account
    let transaction: UnconfirmedTransaction
    let forceFetchNonce: Bool
    let server: RPCServer
    let chainState: ChainState
    var configuration: TransactionConfiguration {
        didSet {
            configurationUpdate.value = configuration
        }
    }
    var requestEstimateGas: Bool
    
    let nonceProvider: NonceProvider
    var configurationUpdate: Subscribable<TransactionConfiguration> = Subscribable(nil)
    
    
    let provider: MoyaProvider<RPCApi> =  ApiProviderFactory.makeRPCNetworkProvider()
    
    init(
        session: WalletSession,
        account: Account,
        transaction: UnconfirmedTransaction,
        server: RPCServer,
        chainState: ChainState,
        forceFetchNonce: Bool = true
        ) {
        self.session = session
        self.account = account
        self.transaction = transaction
        self.server = server
        self.chainState = chainState
        self.forceFetchNonce = forceFetchNonce
        self.requestEstimateGas = transaction.gasLimit == .none
        
        let data: Data = TransactionConfigurator.data(for: transaction, from: account.address)
        let calculatedGasLimit = transaction.gasLimit ?? TransactionConfigurator.gasLimit(for: transaction.transfer.type)
        let calculatedGasPrice = min(max(transaction.gasPrice ?? chainState.gasPrice ?? GasPriceConfiguration.default, GasPriceConfiguration.min), GasPriceConfiguration.max)
        
        let nonceProvider = GetNonceProvider(storage: session.transactionsStorage, server: server, address: account.address, provider: self.provider)
        self.nonceProvider = nonceProvider
        
        self.configuration = TransactionConfiguration(
            gasPrice: calculatedGasPrice,
            gasLimit: calculatedGasLimit,
            data: data,
            nonce: transaction.nonce ?? BigInt(nonceProvider.nextNonce ?? -1)
        )
    }
    
    private static func data(for transaction: UnconfirmedTransaction, from: Address) -> Data {
        guard let to = transaction.to else { return Data() }
        switch transaction.transfer.type {
        case .ether:
            return transaction.data ?? Data()
        case .token:
            return ERC20Encoder.encodeTransfer(to: to, tokens: transaction.value.magnitude)
        }
    }
    
    private static func gasLimit(for type: TransferType) -> BigInt {
        switch type {
        case .ether:
            return GasLimitConfiguration.default
        case .token:
            return GasLimitConfiguration.tokenTransfer
        }
    }
    private static func gasPrice(for type: Transfer) -> BigInt {
        return GasPriceConfiguration.default
    }
    
    func load(completion: @escaping (Result<Void, AnyError>) -> Void) {
        if requestEstimateGas {
            estimateGasLimit { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let gasLimit):
                    self.refreshGasLimit(gasLimit)
                case .failure: break
                }
            }
        }
        loadNonce(completion: completion)
    }
    


    
    
    
    func previewTransaction() -> PreviewTransaction {
        return PreviewTransaction(
            value: valueToSend(),
            account: account,
            address: transaction.to,
            contract: .none,
            nonce: configuration.nonce,
            data: configuration.data,
            gasPrice: configuration.gasPrice,
            gasLimit: configuration.gasLimit,
            transfer: transaction.transfer
        )
    }
    
    var signTransaction: SignTransaction {
        let value: BigInt = {
            switch transaction.transfer.type {
            case .ether: return valueToSend()
            case .token: return 0
            }
        }()
        let address: EthereumAddress? = {
            switch transaction.transfer.type {
            case .ether: return transaction.to
            case .token(let token): return token.contractAddress
            }
        }()
        let localizedObject: LocalizedOperationObject? = {
            switch transaction.transfer.type {
            case .ether: return .none
            case .token(let token):
                return LocalizedOperationObject(
                    from: account.address.description,
                    to: transaction.to?.description ?? "",
                    contract: token.contract,
                    type: OperationType.tokenTransfer.rawValue,
                    value: BigInt(transaction.value.magnitude).description,
                    symbol: token.symbol,
                    name: token.name,
                    decimals: token.decimals
                )
            }
        }()
        
        let signTransaction = SignTransaction(
            value: value,
            account: account,
            to: address,
            nonce: configuration.nonce,
            data: configuration.data,
            gasPrice: configuration.gasPrice,
            gasLimit: configuration.gasLimit,
            chainID: server.chainID,
            localizedObject: localizedObject
        )
        return signTransaction
    }
    
    
    // combine into one function
    
    func refreshGasLimit(_ gasLimit: BigInt) {
        configuration = TransactionConfiguration(
            gasPrice: configuration.gasPrice,
            gasLimit: gasLimit,
            data: configuration.data,
            nonce: configuration.nonce
        )
    }
    func refreshNonce(_ nonce: BigInt) {
        configuration = TransactionConfiguration(
            gasPrice: configuration.gasPrice,
            gasLimit: configuration.gasLimit,
            data: configuration.data,
            nonce: nonce
        )
    }
    func loadNonce(completion: @escaping (Result<Void, AnyError>) -> Void) {
        nonceProvider.getNextNonce(force: forceFetchNonce) { [weak self] result in
            switch result {
            case .success(let nonce):
                self?.refreshNonce(nonce)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func valueToSend() -> BigInt {
        var value = transaction.value
        switch transaction.transfer.type.token.type {
        case .coin:
            let balance = Balance(value: transaction.transfer.type.token.valueBigInt)
            if !balance.value.isZero && balance.value == transaction.value {
                value = transaction.value - configuration.gasLimit * configuration.gasPrice
                //We work only with positive numbers.
                if value.sign == .minus {
                    value = BigInt(value.magnitude)
                }
            }
            return value
        case .ERC20:
            return value
        }
    }
    func estimateGasLimit(completion: @escaping (Result<BigInt, AnyError>) -> Void) {
        provider.request(.estimateGasLimit(server: self.server, transaction: signTransaction)) { (result) in
            
            switch result {
            case .success(let response):
                guard let responseValue:[String: Any] = (try! response.mapJSON() as? [String: Any]),let gasLimitHash = responseValue["result"] as? String, let value = BigInt(gasLimitHash.drop0x, radix: 16) else{
                    completion(.success(BigInt()))
                    return
                }
                if value == BigInt(21000) {
                    completion(.success(value))
                }else{
                    completion(.success(value + (value * 20 / 100)))
                }
                
            case .failure(let error):
                completion(.failure(AnyError(error)))
            }
        }
    }
  
}


