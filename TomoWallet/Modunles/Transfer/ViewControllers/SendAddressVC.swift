//
//  SendViewController.swift
//  TomoWallet
//
//  Created by TomoChain on 8/24/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import TrustCore
import TrustKeystore

import QRCodeReaderViewController
protocol SendViewController_Delegate:class {
    func didPressConfirm(toAddress: EthereumAddress, data: Data, in viewController: SendAddressVC)
}

class SendAddressVC: BaseViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    let viewModel: SendViewModel
    weak var delegate: SendViewController_Delegate?
    private var data = Data()
    init(viewModel: SendViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.titile
        self.setDoneOnKeyboard()
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapAction)
    }
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.tintColor = .white
        keyboardToolbar.barTintColor = UIColor(hex: "151515")
        let nextButton = UIButton()
        nextButton.setImage(#imageLiteral(resourceName: "ArrowLeft"), for: .normal)
        nextButton.setTitle("NEXT  ", for: .normal)
        nextButton.semanticContentAttribute = .forceRightToLeft
        nextButton.addTarget(self, action: #selector(self.NextAction(_:)), for: .touchUpInside)
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nextBarButton = UIBarButtonItem(customView: nextButton)
        keyboardToolbar.items = [ flexBarButton, nextBarButton]
        self.addressTextField.inputAccessoryView = keyboardToolbar
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func NextAction(_ sender: Any) {
        guard let address = EthereumAddress(string: self.addressTextField.text!) else {
            return (self.navigationController as? NavigationController)!.displayError(error: Errors.invalidAddress)
        }
        self.delegate?.didPressConfirm(toAddress: address, data: self.data, in: self)
    }
    @IBAction func qrCodeReaderAction(_ sender: Any) {
        let controller = QRCodeReaderViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
}
extension SendAddressVC: QRCodeReaderDelegate {
    func readerDidCancel(_ reader: QRCodeReaderViewController!) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
    }
    func reader(_ reader: QRCodeReaderViewController!, didScanResult result: String!) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
        guard let result = QRURLParser.from(string: result) else {
            return (self.navigationController as? NavigationController)!.displayError(error: Errors.invalidAddress)
        }
        self.addressTextField.text = result.address
        if let dataString = result.params["data"] {
            data = Data(hex: dataString.drop0x)
        } else {
            data = Data()
        }
    }
}
