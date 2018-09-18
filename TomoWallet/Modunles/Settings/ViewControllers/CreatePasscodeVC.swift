//
//  CreatePasscodeVC.swift
//  TomoWallet
//
//  Created by TomoChain on 9/18/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
protocol CreatePasscodeVC_Delegate: class {
    func didCloseAction()
}

class CreatePasscodeVC: BaseViewController {
    weak var delegate: CreatePasscodeVC_Delegate?
    lazy var numberPageView: NumberPageView = {
        let view = Bundle.main.loadNibNamed("NumberPageView", owner: self, options: nil)?.first as! NumberPageView
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigation()

    }
    func createNavigation() {
        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Close"), style: .plain, target: self, action: #selector(self.closeAction))
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closeAction() {
        self.delegate?.didCloseAction()
    }
}
