//
//  NewTokenERC20VC.swift
//  TomoWallet
//
//  Created by TomoChain on 9/4/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import TrustCore
import QRCodeReaderViewController
import PromiseKit
import MBProgressHUD
protocol NewTokenERC20VC_Delegate:class {
    func didAddToken(token: ERC20Token, in viewController: NewTokenERC20VC)
}

class NewTokenERC20VC: UIViewController {
    @IBOutlet weak var contractAddressTextField: UITextField!
    @IBOutlet weak var contractNameTextField: UITextField!
    @IBOutlet weak var contractSymbolTextField: UITextField!
    @IBOutlet weak var contractDecimalsTextField: UITextField!
    @IBOutlet weak var pasteContractAddressButton: UIButton!
    @IBOutlet weak var scanQRButton: UIButton!
    @IBOutlet weak var addContracButton: UIButton!
    
    private var viewModel: NewTokenViewModel
    weak var delegate: NewTokenERC20VC_Delegate?
    init(viewModel: NewTokenViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
       
        scanQRButton.setImage(#imageLiteral(resourceName: "Receive").imageWithColor(color1: UIColor(hex: "00A7FF")), for: .normal)
        self.setDoneOnKeyboard()
        contractAddressTextField.delegate = self
    }

    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.contractAddressTextField.inputAccessoryView = keyboardToolbar
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setHiddenPasteboardAction() {
        if (self.contractAddressTextField.text?.isEmpty)!{
            self.pasteContractAddressButton.isHidden = false
        }else{
            self.pasteContractAddressButton.isHidden = true
        }
    }

    
    
    @IBAction func qrCodeReaderAction(_ sender: Any) {
        let controller = QRCodeReaderViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
 
    private func updateContractValue(value: String) {
        guard let address = EthereumAddress(string: value) else {
            return (self.contractAddressTextField.placeholder = Errors.invalidAddress.errorDescription)
        }
        self.contractAddressTextField.text = address.description
        self.setHiddenPasteboardAction()
        fetchInfo(for: address.description)
    }
    
    private func fetchInfo(for contract: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.addContracButton.isEnabled = false
        firstly {
            viewModel.info(for: contract)
            }.done { [weak self] token in
                guard let `self` = self else{return}
                self.reloadFields(with: token)
            }.ensure { [weak self] in
                guard let `self` = self else{return}
                MBProgressHUD.hide(for: (self.view)!, animated: true)
                self.addContracButton.isEnabled = true
            }.catch {_ in
             //   We could not find any info about this contract.This error is already logged in crashlytics.
        }
    }
    private func reloadFields(with token: TokenObject) {
        self.contractNameTextField.text = token.name
        self.contractDecimalsTextField.text = token.decimals.description
        self.contractSymbolTextField.text = token.symbol
       

    }
    @IBAction func pasteboardAction(_ sender: UIButton) {
        guard let pageString = UIPasteboard.general.string else{
            return
        }
        self.contractAddressTextField.text = pageString
        
    }
    @IBAction func addContractAction(_ sender: UIButton) {
        guard let address = EthereumAddress(string: self.contractAddressTextField.text ?? "") else {
            return (self.navigationController as? NavigationController)!.displayError(error: Errors.invalidAddress)
           
        }
        
        let token = ERC20Token(
            contract: address,
            name: self.contractNameTextField.text ?? "",
            symbol: self.contractSymbolTextField.text ?? "",
            decimals: Int(self.contractDecimalsTextField.text ?? "") ?? 0,
            coin: viewModel.coin
        )
        
        delegate?.didAddToken(token: token, in: self)
        
    }

}
extension NewTokenERC20VC: QRCodeReaderDelegate{
    func readerDidCancel(_ reader: QRCodeReaderViewController!) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
    }
    func reader(_ reader: QRCodeReaderViewController!, didScanResult result: String!) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
        guard let result = QRURLParser.from(string: result) else { return }
        updateContractValue(value: result.address)
    }
}
extension NewTokenERC20VC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setHiddenPasteboardAction()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setHiddenPasteboardAction()
    }
 
}
