//
//  WelcomeVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/9/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol WelcomeVC_Delegate: class {
    func didPressCreateWallet(in viewController: WelcomeVC)
    func didPressImportWallet(in viewController: WelcomeVC)
}

class WelcomeVC: UIViewController {
    
    weak var delegate : WelcomeVC_Delegate?
    var keystore: Keystore?

    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        keystore?.createAccount(with: "tomochain") { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
         
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    
    @IBAction func createWalletAction(_ sender: Any) {
        delegate?.didPressCreateWallet(in: self)

    }
  
    @IBAction func importWalletAction(_ sender: Any) {
        delegate?.didPressImportWallet(in: self)
    }
}
