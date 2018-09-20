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
    @IBOutlet weak var importWalletButton: UIButton!
    @IBOutlet weak var createWalletButton: UIButton!
    weak var delegate : WelcomeVC_Delegate?
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillLayoutSubviews()  {
        print(self.createWalletButton.bounds.size.height)
        self.createWalletButton.layer.cornerRadius = self.createWalletButton.bounds.size.height/2
        self.importWalletButton.layer.cornerRadius = self.importWalletButton.bounds.size.height/2
    }
    
    
    @IBAction func createWalletAction(_ sender: Any) {
        delegate?.didPressCreateWallet(in: self)

    }
  
    @IBAction func importWalletAction(_ sender: Any) {
        delegate?.didPressImportWallet(in: self)
    }
}
