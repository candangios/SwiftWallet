//
//  SendAmountVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/24/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import TrustCore
import TrustKeystore
import BigInt

protocol SendAmountVC_Delegate: class {
    func didPressConfirm(
        transaction: UnconfirmedTransaction,
        transfer: Transfer,
        in viewController: SendAmountVC
    )
}



enum SendInputErrors: LocalizedError {
    case emptyClipBoard
    case wrongInput
    
    var errorDescription: String? {
        switch self {
        case .emptyClipBoard:
            return NSLocalizedString("send.error.emptyClipBoard", value: "Empty ClipBoard", comment: "")
        case .wrongInput:
            return NSLocalizedString("send.error.wrongInput", value: "Wrong Input", comment: "")
        }
    }
}


class SendAmountVC: BaseViewController {
    
    private lazy var viewModel: SendAmountViewModel = {
        let balance = Balance(value: transfer.type.token.valueBigInt)
        return .init(transfer: transfer, config: session.config, chainState: chainState, storage: storage, balance: balance, toAddress: toAddress)
    }()
    let session: WalletSession
    let account: Account
    let transfer: Transfer
    let storage: TokensDataStore
    let chainState: ChainState
    let toAddress: EthereumAddress
    let data: Data
    @IBOutlet weak var toAddressLable: UILabel!
    @IBOutlet weak var amountLable: UILabel!
    @IBOutlet weak var symbolLable: UILabel!
    
    weak var delegate: SendAmountVC_Delegate?
    var operation = true
    
    init(
        session: WalletSession,
        storage: TokensDataStore,
        account: Account,
        transfer: Transfer,
        chainState: ChainState,
        toAddress: EthereumAddress,
        data: Data
        ) {
        self.session = session
        self.account = account
        self.transfer = transfer
        self.storage = storage
        self.chainState = chainState
        self.toAddress = toAddress
        self.data = data
        super.init(nibName: nil, bundle: nil)
    
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        self.amountLable.text = viewModel.defaultAmount
        self.amountLable.adjustsFontSizeToFitWidth = true
        self.setHeaderView()
    }
    func setHeaderView()  {
        self.toAddressLable.text = viewModel.toAddress.description
        self.symbolLable.text = viewModel.symbol
    }
    
    //appending number to label
    func Addnumberfunc(number:String){
//        if (self.amountLable.text?.count)! > 6 {
//            return
//        }
        if self.amountLable.text == viewModel.defaultAmount{
            self.amountLable.text = ""
        }
        var textnum = String(amountLable.text!)
        textnum = textnum + number
        amountLable.text = textnum
        
        
    }

    
    
    @IBAction func getValueFromNumber(_ sender: CalculatorButton) {
        switch sender.tag {
        case 11:
            
            // dot character
             self.Addnumberfunc(number: ".")
        case 12:
            //delete last character
            if self.amountLable.text == viewModel.defaultAmount{
                return
            }
            if self.amountLable.text?.count == 1{
                self.amountLable.text = viewModel.defaultAmount
                return
            }
            self.amountLable.text = String((amountLable.text?.dropLast())!)
        default:
            // numbers character
            self.Addnumberfunc(number: "\(sender.tag)")
        }
        
        
    }
    
    
    
    
    @IBAction func sendAction(_ sender: Any) {
        
        self.viewModel.amount = self.amountLable.text ?? viewModel.defaultAmount
        let amountString = viewModel.amount
        let parsedValue: BigInt? = {
            switch transfer.type {
            case .ether:
                return EtherNumberFormatter.full.number(from: amountString, units: .ether)
            case .token(let token):
                return EtherNumberFormatter.full.number(from: amountString, decimals: token.decimals)
            }
        }()
        guard let value = parsedValue else {
            return (self.navigationController as? NavigationController)!.displayError(error: SendInputErrors.wrongInput)
        }
        let transaction = UnconfirmedTransaction(
            transfer: transfer,
            value: value,
            to: toAddress,
            data: data,
            gasLimit: .none,
            gasPrice: viewModel.gasPrice,
            nonce: .none
        )
        self.delegate?.didPressConfirm(transaction: transaction, transfer: transfer, in: self)
        
        
    }
    


}
