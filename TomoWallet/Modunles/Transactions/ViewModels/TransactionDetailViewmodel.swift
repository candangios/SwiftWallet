//
//  TransactionsViewmodel.swift
//  TomoWallet
//
//  Created by TomoChain on 8/21/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustKeystore
import BigInt
final class TransactionDetailViewModel {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    private let transactionViewModel: TransactionViewModel
    private let transaction: Transaction
    private let config: Config
    private let chainState: ChainState
    private let shortFormatter = EtherNumberFormatter.short
    private let fullFormatter = EtherNumberFormatter.full
    private let session: WalletSession
    private let server: RPCServer
    private let token: TokenObject
    
    private var transactionsProvider:TransactionsProvider?
    private var blockTimer: Timer?
    
    private var gasViewModel: GasViewModel {
        let gasUsed = BigInt(transaction.gasUsed) ?? BigInt()
        let gasPrice = BigInt(transaction.gasPrice) ?? BigInt()
        let gasLimit = BigInt(transaction.gas) ?? BigInt()
        let gasFee: BigInt = {
            switch transaction.state {
            case .completed, .error: return gasPrice * gasUsed
            case .pending, .unknown, .failed, .deleted: return gasPrice * gasLimit
            }
        }()
        return GasViewModel(fee: gasFee, server: server, store: session.tokensStorage, formatter: fullFormatter)
    }
    init(
        transaction: Transaction,
        config: Config,
        chainState: ChainState,
        currentAccount: Account,
        session: WalletSession,
        server: RPCServer,
        token: TokenObject
        ) {
        self.transaction = transaction
        self.config = config
        self.chainState = chainState
        self.session = session
        self.transactionViewModel = TransactionViewModel(
            transaction: transaction,
            config: config,
            currentAccount: currentAccount,
            server: server,
            token: token
        )
        self.server = server
        self.token = token
        switch transaction.state {
        case .pending:
            self.transactionsProvider = TransactionsProvider(server: server, provider: ApiProviderFactory.makeRPCNetworkProvider())
            self.blockTimer = Timer.scheduledTimer(timeInterval: TimeInterval(server.blockTime), target: self, selector:#selector(self.runTimedCode), userInfo: nil, repeats: true)
        default:
            self.transactionsProvider = TransactionsProvider(server: server, provider: ApiProviderFactory.makeRPCNetworkProvider())
            self.blockTimer = Timer.scheduledTimer(timeInterval: TimeInterval(server.blockTime), target: self, selector:#selector(self.runTimedCode), userInfo: nil, repeats: true)
            break
        }
        
       

    }

    @objc func runTimedCode() {
        transactionsProvider?.update(for: self.transaction) { (result) in
            switch result{
            case .success(let transaction, let state):
                self.blockTimer?.invalidate()
                

            //                self.transactionsStore.update(state: state, for: transaction)
            case .failure(let error):
                break
            }
        }
    }
    func invalidate()  {
        self.blockTimer?.invalidate()
    }
    
    var createdAt: String{
        return TransactionDetailViewModel.dateFormatter.string(from: transaction.date)
    }
    var amountString: String {
        return transactionViewModel.amountFullText
    }
    var amountTextColor: UIColor{
        return transactionViewModel.amountTextColor
    
    }
    var stateString: String{
        return transaction.state.description
    }
    var gasFee: String{
        return gasViewModel.etherFee
    }

    
    var titleHeader: String{
        return transactionState
    }
    var statusImage: UIImage? {

        return transactionViewModel.statusImage
    }
    

    var fromAddress: String{
        return transactionViewModel.transactionFrom
    }
    var toAddress: String{
        return transactionViewModel.transactionTo
    }
    
    private var transactionState : String {
        switch transaction.state {
        case .completed:
            switch transactionViewModel.direction {
            case .incoming:
                return "You are Received \(transactionViewModel.amountNomalText) from \(toAddress)"
            case .outgoing:
                return "You are sending \(transactionViewModel.amountNomalText) to \(toAddress)"
            case .sendToYourself:
                return "You are sending \(transactionViewModel.amountNomalText) to yourself"
            }
        case .error:
            return "Transaction Error"
        case .failed:
            return "Transaction Failed"
        case .unknown:
            return "Transaction Unknown"
        case .pending:
            return "Transaction Pending"
        case .deleted:
            return ""
        }
    }
  
    
}
