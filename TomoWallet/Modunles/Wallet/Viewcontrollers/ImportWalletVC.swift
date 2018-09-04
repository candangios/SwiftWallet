//
//  ImportWalletVC.swift
//  TomoWallet
//
//  Created by Admin on 9/3/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import TrustKeystore

class ImportWalletVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WalletInfo {
    static var emptyName: String {
        return "Unnamed " + "Wallet"
    }
    
    static func initialName(index numberOfWallets: Int) -> String {
        return String(format: "%@ %@", "Wallet", "\(numberOfWallets + 1)")
        
    }
}
