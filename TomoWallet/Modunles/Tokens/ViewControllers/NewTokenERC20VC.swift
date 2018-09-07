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

class NewTokenERC20VC: UIViewController {
    @IBOutlet weak var contractAddressTextField: UITextField!
    @IBOutlet weak var contractNameTextField: UITextField!
    @IBOutlet weak var contractSymbolTextField: UITextField!
    @IBOutlet weak var contractDecimalsTextField: UITextField!
    @IBOutlet weak var pasteContractAddressButton: UIButton!
    @IBOutlet weak var scanQRButton: UIButton!
    @IBOutlet weak var addContracButton: UIButton!
    
    private var viewModel: NewTokenViewModel
    init(viewModel: NewTokenViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewModel.title
        self.addContracButton.isEnabled = false
        scanQRButton.setImage(#imageLiteral(resourceName: "Receive").imageWithColor(color1: UIColor(hex: "00A7FF")), for: .normal)
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
        fetchInfo(for: address)
    }
    
    private func fetchInfo(for contract: EthereumAddress) {
        viewModel.info(for: contract)
//        displayLoading()
//        firstly {
//            view
////            viewModel.info(for: contract)
//            }.done { [weak self] token in
////                self?.reloadFields(with: token)
//            }.ensure { [weak self] in
////                self?.hideLoading()
//            }.catch {_ in
//                //We could not find any info about this contract.This error is already logged in crashlytics.
//        }
    }
    @IBAction func addContractAction(_ sender: Any) {
        
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
