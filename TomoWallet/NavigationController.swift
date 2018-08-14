//
//  NavigationController.swift
//  TomoWallet
//
//  Created by TomoChain on 8/13/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
