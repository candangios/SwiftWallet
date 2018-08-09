//
//  WelcomeVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/9/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

protocol WelcomeVC_Delegate: class {
    func didPressCreateWallet(in viewController: WelcomeVC)
    func didPressImportWallet(in viewController: WelcomeVC)
}

class WelcomeVC: UIViewController {
    
    weak var delegate : WelcomeVC_Delegate?

    override func viewDidLoad() {
        super.viewDidLoad()
 
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
