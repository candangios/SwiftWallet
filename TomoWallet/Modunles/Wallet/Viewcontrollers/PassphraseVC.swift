//
//  PassphraseVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/16/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import TrustCore
import TrustKeystore

class PassphraseVC: UIViewController {
    let account: Wallet
    let words: [String]
    init(account: Wallet, words: [String]) {
        self.account = account
        self.words = words
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
