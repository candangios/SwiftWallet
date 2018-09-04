//
//  ConfirmPaymentVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/27/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import BigInt
import Foundation
import UIKit
import Result
import StatefulViewController

import MBProgressHUD

enum ConfirmType {
    case sign
    case signThenSend
}

enum ConfirmResult {
    case signedTransaction(SentTransaction)
    case sentTransaction(SentTransaction)
}

class ConfirmPaymentVC: UIViewController {
    @IBOutlet weak var toAddressLable: UILabel!
    @IBOutlet weak var amountValueLable: UILabel!
    @IBOutlet weak var symbolLable: UILabel!
    
    private let keystore: Keystore
    let session: WalletSession
    lazy var sendTransactionCoordinator = {
        return SendTransactionCoordinator(session: self.session, keystore: keystore, confirmType: confirmType, server: server)
    }()
    
    lazy var viewModel: ConfirmPaymentViewModel = {
        //TODO: Refactor
        return ConfirmPaymentViewModel(type: self.confirmType)
    }()
    var configurator: TransactionConfigurator
    let confirmType: ConfirmType
    let server: RPCServer
    var didCompleted: ((Result<ConfirmResult, AnyError>) -> Void)?

    init(
        session: WalletSession,
        keystore: Keystore,
        configurator: TransactionConfigurator,
        confirmType: ConfirmType,
        server: RPCServer
        ) {
        self.session = session
        self.keystore = keystore
        self.configurator = configurator
        self.confirmType = confirmType
        self.server = server
        
        super.init(nibName: nil, bundle: nil)
        fetch()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.title
        self.setHeaderView()
    }
    
    func setHeaderView()  {
        self.toAddressLable.text = configurator.previewTransaction().address?.description
//        self.amountValueLable.text =  configurator.previewTransaction().value
        
    }
    
    
    
    func fetch() {
       
        let hup = MBProgressHUD.showAdded(to: self.view, animated: true)
        hup.label.text = "EstimateGas"
        configurator.load { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                hup.hide(animated: true)
                
                break
            case .failure(let error):
                print(error)
                hup.hide(animated: true)
//                self.endLoading(animated: true, error: error, completion: nil)
            
            }
        }
        configurator.configurationUpdate.subscribe { [weak self] _ in
//            guard let `self` = self else { return }
//            self.reloadView()
        }
    }


    @IBAction func sendAction(_ sender: Any) {
//
        
        let transaction = configurator.signTransaction
        self.sendTransactionCoordinator.send(transaction: transaction) { [weak self] result in
            guard let `self` = self else { return }
            self.didCompleted?(result)
//            self.hideLoading()
        }
        
    }
}
