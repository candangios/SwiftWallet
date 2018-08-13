//
//  WalletCreatedVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/9/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class WalletCreatedVC: UIViewController {

    @IBOutlet weak var importWalletButton: UIButton!
    @IBOutlet weak var createWalletButton: UIButton!
    
    
    let viewModel: WalletCreateViewModel
   
    
    init(viewModel: WalletCreateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "WalletCreatedVC.xib", bundle: nil)
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
    
    // Action
    @IBAction func createWalletAction(_ sender: Any) {
    }
    

}
