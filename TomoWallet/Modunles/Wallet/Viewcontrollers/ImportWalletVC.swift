//
//  ImportWalletVC.swift
//  TomoWallet
//
//  Created by Admin on 9/3/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import TrustKeystore
import TrustCore
import QRCodeReaderViewController
import MBProgressHUD
protocol ImportWalletVC_Delegate: class {
    func didImportAccount(account: WalletInfo, fields: [WalletInfoField], in viewController: ImportWalletVC)
}

enum ImportSelectionType {
    case privateKey(privateKey: String )
    case mnemonic(mnemonicWords: [String] )
    case unKnown
}
extension WalletInfo {
    static var emptyName: String {
        return "Unnamed " + "Wallet"
    }
    
    static func initialName(index numberOfWallets: Int) -> String {
        return String(format: "%@ %@", "Wallet", "\(numberOfWallets + 1)")
        
    }
}

class ImportWalletVC: BaseViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var importButton: RadiusButton!
    @IBOutlet weak var qrcodeScanButton: BolderButton!
    @IBOutlet weak var inputTextView: UITextView!
    let textViewPlaceholder = "Enter your private key or recovery phrase"
    let textViewPlaceholderColor = UIColor(hex: "838383")
    let textViewHighlightColor = UIColor(hex: "333333")
    weak var delegate: ImportWalletVC_Delegate?
    
    let initialName: String
    let keystore: Keystore
    let coin: Coin
    var importSectionType = ImportSelectionType.unKnown
    private lazy var viewModel: ImportWalletViewModel = {
        return ImportWalletViewModel(coin: coin)
    }()
    
    init(keystore: Keystore,for coin: Coin) {
        self.keystore = keystore
        self.coin = coin
        self.initialName = WalletInfo.initialName(index: keystore.wallets.count)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.qrcodeScanButton.setImage(#imageLiteral(resourceName: "Receive").imageWithColor(color1: UIColor(hex: "333333")), for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.backgroundView.addGestureRecognizer(tap)
        
        self.inputTextView.text = textViewPlaceholder
        self.inputTextView.textColor = textViewPlaceholderColor
        self.inputTextView.layer.cornerRadius = 5
        self.setDoneOnKeyboard()
        
        
        let type = ImportType.address(address: EthereumAddress(string: "0xe6350e88Bb5396b7B6109c405576756b3a909107")!)
        keystore.importWallet(type: type, coin: .ethereum) { (result) in
            switch result {
            case .success(let account):
                self.didImport(account: account, name: self.initialName)
            case .failure(let error):
                (self.navigationController as? NavigationController)?.displayError(error: error)
            }
        }
        
    }
    
    @IBAction func pasteboardAction(_ sender: Any) {
        guard let pageString = UIPasteboard.general.string else{
            return
        }
        self.inputTextView.text = pageString
        self.inputTextView.textColor = textViewHighlightColor
    }
    @IBAction func qrCodeReaderAction(_ sender: Any) {
        let controller = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObject.ObjectType.qr])
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

    @IBAction func importWalletAction(_ sender: UIButton) {
        sender.isEnabled = false
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let importType: ImportType? = {
            switch importSectionType {
            case .mnemonic(let words):
                return ImportType.mnemonic(words: words, password: "", derivationPath: coin.derivationPath(at: 0))
                
            case .privateKey(let privateKey):
                return ImportType.privatekey(privatekey: privateKey)
            case .unKnown:
                MBProgressHUD.hide(for: self.view, animated: true)
                sender.isEnabled = true
                return .none
            }
        }()
        if importType != nil{
            keystore.importWallet(type: importType!, coin: coin) { (result) in
                MBProgressHUD.hide(for: self.view, animated: true)
                sender.isEnabled = true
                switch result {
                case .success(let account):
                    self.didImport(account: account, name: self.initialName)
                case .failure(let error):
                    (self.navigationController as? NavigationController)?.displayError(error: error)
                }
            }
        } else{
            sender.isEnabled = true
             (self.navigationController as? NavigationController)?.displayError(error: KeystoreError.invalidMnemonicPhraseorPrivatekey)
        }
   
    }
    
    func didImport(account: WalletInfo, name: String) {
        delegate?.didImportAccount(account: account, fields: [
            .name(name),
            .backup(true),
            ], in: self)
    }
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputTextView.inputAccessoryView = keyboardToolbar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func checkStringResult(result: String) {
        let words = result.components(separatedBy: " ")
        if words.count == 12{
            self.importSectionType = .mnemonic(mnemonicWords: words)
           
            
        }else if Data(hexString: result) != nil{
            self.importSectionType = .privateKey(privateKey: result)

        }
        self.inputTextView.text = result
        self.inputTextView.textColor = textViewHighlightColor
    }

}
extension ImportWalletVC: QRCodeReaderDelegate{
    func readerDidCancel(_ reader: QRCodeReaderViewController!) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
    }
    func reader(_ reader: QRCodeReaderViewController!, didScanResult result: String!) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)
        self.checkStringResult(result: result)
     
       
    }
}
extension ImportWalletVC: UITextViewDelegate{
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == textViewPlaceholderColor {
            textView.text = nil
            textView.textColor = textViewHighlightColor
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = textViewPlaceholderColor
        }else{
            self.checkStringResult(result: textView.text)
        }
    }
    
}



