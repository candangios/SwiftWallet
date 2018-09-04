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
protocol PassphraseVC_Delegate:class {
    func didPressVerify(in controller: PassphraseVC, with account: Wallet, words: [String])
    func didSkip(in controller: PassphraseVC, with account: Wallet)
}

class PassphraseVC: UIViewController {
    @IBOutlet weak var containerView: UIView!
    let account: Wallet
    let words: [String]
    weak var delegate: PassphraseVC_Delegate?
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
        self.navigationItem.setHidesBackButton(true, animated: false)
        set12WordsView()

        // Do any additional setup after loading the view.
    }
   
    
    
    func set12WordsView() {
        let width = UIScreen.main.bounds.width/2
        for index in 0..<self.words.count {
            guard let view = Bundle.main.loadNibNamed("WordPhraseView", owner: nil, options: nil)?.first as? WordPhraseView else{
                return
            }
            if index < 6{
    
                view.frame = CGRect(x: 0, y: index * 39, width: Int(width), height: 39)
                
            }else{
                view.frame = CGRect(x: Int(width), y: (index - 6) * 39, width: Int(width), height: 39)
            }
            view.setView(wordPhrase: self.words[index], ordinalNumber: "\(index + 1)")
            self.containerView.addSubview(view)
         
        }
        
    }

  


    @IBAction func didCancellAction(_ sender: Any) {
        self.delegate?.didSkip(in: self, with: self.account)
    }
    @IBAction func veryfyAction(_ sender: Any) {
        self.delegate?.didPressVerify(in: self, with: account, words: words)
    }
}
