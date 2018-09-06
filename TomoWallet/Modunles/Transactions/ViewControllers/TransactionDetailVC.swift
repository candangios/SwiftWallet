//
//  PaymentDetailVC.swift
//  TomoWallet
//
//  Created by TomoChain on 9/5/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import Kingfisher

class TransactionDetailVC: UIViewController {

    @IBOutlet weak var transactionToAddressLable: UILabel!
    @IBOutlet weak var transactionFromAddressLable: UILabel!
    @IBOutlet weak var transactionFeeLable: UILabel!
    @IBOutlet weak var transactionAmountLable: UILabel!
    @IBOutlet weak var transactionTimeLable: UILabel!
    @IBOutlet weak var transactionsStateLable: UILabel!
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

    
    init(session: WalletSession, transaction: Transaction, tokenViewModel: TokenViewModel) {
        self.session = session
        self.transaction = transaction
        self.tokenViewModel = tokenViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }

    @IBAction func closeAction(_ sender: Any) {
    }
    
    @IBAction func pressURLAction(_ sender: Any) {
    }
}
