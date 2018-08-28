//
//  NavigationController.swift
//  TomoWallet
//
//  Created by TomoChain on 8/13/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

import MBProgressHUD

class NavigationController: UINavigationController {
    let _isHiddenNavigationBar: Bool
    init(isHiddenNavigationBar: Bool) {
        _isHiddenNavigationBar = isHiddenNavigationBar
        super.init(nibName: nil, bundle: nil)
        self.setNavigationBarHidden(_isHiddenNavigationBar, animated: true)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor(hex: "151515")
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.isTranslucent = false
        self.navigationBar.barStyle = .blackTranslucent
    
   
//        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func displayLoading(text: String, animated: Bool)  {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: animated)
        hud.label.text = "Creating Wallet..."
    }
    func hideLoading(animated: Bool)  {
        MBProgressHUD.hide(for: self.view, animated: animated)
    }
    
    func displayError(error: Error) {
        let alertController = UIAlertController(title: error.prettyError, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    


}
