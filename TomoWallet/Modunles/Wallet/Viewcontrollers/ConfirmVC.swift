//
//  DarkPassphraseVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/16/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import TrustKeystore
protocol ConfrimVC_Delegate: class{
    func didPressVerify(in controller: ConfirmVC, with account: Wallet, words: [String])
    func didSkip(in controller: ConfirmVC, with account: Wallet)
}

enum WalletInfoField {
    case name(String)
    case backup(Bool)
    case mainWallet(Bool)
    case balance(String)
}

enum PassphraseMode {
    case showOnly
    case showAndVerify
}


class ConfirmVC: BaseViewController {
    @IBOutlet weak var heightContrain: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    let account: Wallet
    let words: [String]
    let mode: PassphraseMode
    weak var delegate: ConfrimVC_Delegate?
    @IBOutlet weak var titleLable: UILabel!
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
        self.scrollview.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0 )

        self.navigationItem.setHidesBackButton(true, animated: false)
        let height = UIScreen.main.bounds.height
        if height > 677{
            self.heightContrain.constant = height
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func didSkipAction(_ sender: Any) {
        self.delegate?.didSkip(in: self, with: self.account)
    }
    @IBAction func backUpMyAccountAction(_ sender: Any) {
        self.delegate?.didPressVerify(in: self, with: account, words: self.words)
    }
}

