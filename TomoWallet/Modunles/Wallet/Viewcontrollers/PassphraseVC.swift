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

class PassphraseVC: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightContrain: NSLayoutConstraint!
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
       
        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Close"), style: .plain, target: self, action: #selector(self.didSKipAction))
        self.navigationItem.rightBarButtonItem = closeButton
        
        let height = UIScreen.main.bounds.height
        if height > 677{
            heightContrain.constant = height
        }
        scrollView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        set12WordsView()

    }
   

    func set12WordsView() {
        let width = UIScreen.main.bounds.width/2
        for index in 0..<self.words.count {
            guard let viewPhase = Bundle.main.loadNibNamed("WordPhraseView", owner: nil, options: nil)?.first as? WordPhraseView else{
                return
            }
            if index < 6{
                viewPhase.frame = CGRect(x: 0, y: CGFloat(index * 39), width: CGFloat(width*2), height: 39)
            }else{
                viewPhase.frame = CGRect(x: width, y:CGFloat((index - 6) * 39) , width: CGFloat(width*2), height: 39)
            }
            viewPhase.setView(wordPhrase: self.words[index], ordinalNumber: "\(index + 1)")
    
            self.containerView.addSubview(viewPhase)
          
        }
    }
  

  


    @objc func didSKipAction() {
        self.delegate?.didSkip(in: self, with: self.account)
    }
    @IBAction func veryfyAction(_ sender: Any) {
        self.delegate?.didPressVerify(in: self, with: account, words: words)
    }
}
