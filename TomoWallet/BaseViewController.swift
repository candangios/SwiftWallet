//
//  BaseViewController.swift
//  TomoWallet
//
//  Created by TomoChain on 9/9/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
    }


}
