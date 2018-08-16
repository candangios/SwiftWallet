//
//  TokensVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
protocol TokensVC_Delegate: class {
    func didPressAddToken( in viewController: UIViewController)

}


class TokensVC: UIViewController {
    fileprivate var viewModel: TokensViewModel
    weak var delegate: TokensVC_Delegate?
    init(viewModel: TokensViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func testDelegate(_ sender: Any) {
        self.delegate?.didPressAddToken(in: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    



}
