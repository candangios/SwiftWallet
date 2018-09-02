//
//  VerifyPassphraseVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/16/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import TrustKeystore
protocol VerifyPassphraseVC_Delegate:class {
    func didFinish(in controller: VerifyPassphraseVC, with account: Wallet)
    func didSkip(in controller: VerifyPassphraseVC, with account: Wallet)
}

class VerifyPassphraseVC: UIViewController {
    let account: Wallet
    let words: [String]
    let mode: PassphraseMode
    weak var delegate: VerifyPassphraseVC_Delegate?
    init(account: Wallet, words:[String], mode: PassphraseMode) {
        self.account = account
        self.words = words
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
