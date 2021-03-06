 //
//  PaymentDetailVC.swift
//  TomoWallet
//
//  Created by TomoChain on 9/5/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import Kingfisher
import JSQWebViewController
import Lottie
enum TransactionDetailVCType {
    case execute
    case detail
}

class TransactionDetailVC: BaseViewController {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var transactionToAddressLable: UILabel!
    @IBOutlet weak var transactionFromAddressLable: UILabel!
    @IBOutlet weak var transactionFeeLable: UILabel!
    @IBOutlet weak var transactionAmountLable: UILabel!
    @IBOutlet weak var transactionTimeLable: UILabel!
    @IBOutlet weak var transactionStatusLable: UILabel!
    @IBOutlet weak var headerTitleLable: UILabel!
    @IBOutlet weak var transactionStateImageView: UIImageView!
    private lazy var viewModel: TransactionDetailViewModel = {
        return TransactionDetailViewModel(
            transaction: self.transaction,
            config: self.config,
            chainState: ChainState(server: tokenViewModel.server, provider: ApiProviderFactory.makeRPCNetworkProvider()),
            currentAccount: tokenViewModel.currentAccount,
            session: session,
            server: tokenViewModel.server,
            token: tokenViewModel.token
        )
    }()

    let session: WalletSession
    let transaction: Transaction
    let config = Config()
    let tokenViewModel: TokenViewModel
    let type: TransactionDetailVCType
    private let transactionsStore: TransactionsStorage
    
    let pendingAnimationView :LOTAnimationView = {
        let pendingView = LOTAnimationView(name: "animation-w400-h400")
        pendingView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        pendingView.contentMode = .scaleAspectFill
        pendingView.loopAnimation = true
        pendingView.play()
        return pendingView
    }()
    

    var didFinishExecute:(()->Void)?

    init(session: WalletSession, transaction: Transaction, tokenViewModel: TokenViewModel, type: TransactionDetailVCType,transactionsStore: TransactionsStorage) {
        self.session = session
        self.transaction = transaction
        self.tokenViewModel = tokenViewModel
        self.type = type
        self.transactionsStore = transactionsStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case .detail:
            self.title = viewModel.createdAt
        case .execute:
            let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Close"), style: .plain, target: self, action: #selector(self.closeAction))
            self.navigationItem.rightBarButtonItem = closeButton
            self.navigationItem.setHidesBackButton(true, animated: false)
        }
        
        headerTitleLable.text = viewModel.titleHeader
        transactionStateImageView.kf.setImage(
            with: tokenViewModel.imageURL,
            placeholder: tokenViewModel.imagePlaceholder
        )
        
        transactionTimeLable.text = viewModel.createdAt
        transactionAmountLable.text = viewModel.amountString
        transactionFeeLable.text = viewModel.gasFee
        transactionFromAddressLable.text = viewModel.fromAddress
        transactionToAddressLable.text = viewModel.toAddress
        transactionStatusLable.text = viewModel.stateString
        switch transaction.state {
        case .pending:
            statusView.addSubview(pendingAnimationView)
        default:
            break
        }
        
      
        
        
        viewModel.didUpdateTransaction = {(transation, state, error) in
            self.pendingAnimationView.removeFromSuperview()
            if error != nil{
                (self.navigationController as? NavigationController)?.displayError(error: error!)
            }else{
                self.transactionsStore.update(state: state, for: transation)
                self.transactionStatusLable.text = self.viewModel.stateString
                self.headerTitleLable.text = self.viewModel.titleHeader
                
            }
        }
    }

    @objc func closeAction() {
        self.didFinishExecute?()
    }
    
    @IBAction func pressURLAction(_ sender: Any) {
     
        let controller = WebViewController(url: URL(string: "https://scan.testnet.tomochain.com/txs/\(transaction.id)")!)
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
           self.viewModel.invalidate()
    }
}
