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
    func didPressConfirm(
        toAddress: EthereumAddress,
        data: Data,
        in viewController: SendViewController
    )
}

class SendViewController: UIViewController {
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension SendViewController: QRCodeReaderDelegate {
    func readerDidCancel(_ reader: QRCodeReaderViewController!) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
    }
    func reader(_ reader: QRCodeReaderViewController!, didScanResult result: String!) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
        guard let result = QRURLParser.from(string: result) else { return }
        self.addressTextField.text = result.address
        if let dataString = result.params["data"] {
            data = Data(hex: dataString.drop0x)
        } else {
            data = Data()
        }


    }
}
