//
//  DarkPassphraseVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/16/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import TrustKeystore
protocol PassphraseVC_Delegate: class{
    func didPressVerify(in controller: ConfirmVC, with account: Wallet, words: [String])
    func didSkip(in controller: ConfirmVC, with account: Wallet)
}


enum PassphraseMode {
    case showOnly
    case showAndVerify
}


class ConfirmVC: UIViewController {
    let account: Wallet
    let words: [String]
    let mode: PassphraseMode
    weak var delegate: PassphraseVC_Delegate?
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

    @IBAction func didSkipAction(_ sender: Any) {
        self.delegate?.didSkip(in: self, with: self.account)
    }
    @IBAction func backUpMyAccountAction(_ sender: Any) {
        self.delegate?.didPressVerify(in: self, with: account, words: self.words)
    }
}
