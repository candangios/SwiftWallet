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

class ConfirmPaymentVC: BaseViewController {
    @IBOutlet weak var toAddressLable: UILabel!
    @IBOutlet weak var amountValueLable: UILabel!
    @IBOutlet weak var symbolLable: UILabel!
    @IBOutlet weak var configView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var estimateFeeLable: UILabel!
    @IBOutlet weak var symbolFeeLable: UILabel!
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
    
//    lazy var configGasPriceView: ConfigGasPriceView? = {
//        guard let view = Bundle.main.loadNibNamed("ConfigGasPriceView", owner: self, options: nil)?.first as? ConfigGasPriceView else{
//            return .none
//        }
//        view.type = .Slow
//        return view
//
//    }()
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
        self.title = viewModel.title
        self.reloadView()
//        self.configView.addSubview(self.configGasPriceView!)
//        self.configGasPriceView?.reloaView(gasPrice: configurator.previewTransaction().gasPrice)
//        self.configGasPriceView?.didSeleted = { newGasPrice in
//            print(EtherNumberFormatter.full.string(from: newGasPrice, units: .gwei))
//            self.configurator.refreshGasPrice(newGasPrice)
//            self.reloadView()
//        }
    
    }
    func reloadView()  {
        let viewDetailModel = ConfrimPaymentDetailViewModel(transaction: configurator.previewTransaction(), session: self.session, server: self.server)
        self.toAddressLable.text = viewDetailModel.toaddress
        self.amountValueLable.text = viewDetailModel.amount
        self.amountValueLable.adjustsFontSizeToFitWidth = true
        self.symbolLable.text = viewDetailModel.amountSymbol
        self.estimateFeeLable.text = viewDetailModel.estimatedFee
        self.symbolFeeLable.text = viewDetailModel.symbolFee
        updateSubmitButton()

    }
    
    
    
    func fetch() {
        let hup = MBProgressHUD.showAdded(to: self.view, animated: true)
        hup.label.text = "Loading..."
        configurator.load { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.reloadView()
                hup.hide(animated: true)
                
            case .failure(let error):
                (self.navigationController as! NavigationController).displayError(error: error)
                hup.hide(animated: true)
            }
        }
        configurator.configurationUpdate.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.reloadView()
        }
   

    }
    
    private func updateSubmitButton() {
        let status = configurator.balanceValidStatus()
        let buttonTitle = viewModel.getActionButtonText(
            status, config: configurator.session.config,
            transfer: configurator.transaction.transfer
        )
        sendButton.isEnabled = status.sufficient
        sendButton.setTitle("\(buttonTitle)  ", for: .normal)
    }
    
  


    @IBAction func sendAction(_ sender: Any) {
        let hup = MBProgressHUD.showAdded(to: self.view, animated: true)
        hup.label.text = "Loading..."
        let transaction = configurator.signTransaction
        self.sendTransactionCoordinator.send(transaction: transaction) { [weak self] result in
            guard let `self` = self else { return }
            hup.hide(animated: true)
           
            self.didCompleted?(result)
           
        }
        
    }
}
