//
//  TokenHeaderView.swift
//  TomoWallet
//
//  Created by TomoChain on 8/23/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

protocol TokenHeaderView_Delegate: class {
    func didPressSend()
    func didPressReveice()
}

class TokenHeaderView: UIView {
    weak var delegate: TokenHeaderView_Delegate?
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconSmallImage: UIImageView!
    @IBOutlet weak var coinNameLable: UILabel!
    @IBOutlet weak var coinNameSmallLable: UILabel!
    @IBOutlet weak var balancelable: UILabel!
    @IBOutlet weak var balanceSmallLable: UILabel!
    @IBOutlet weak var symbolLable: UILabel!
    @IBOutlet weak var symbolSmallLable: UILabel!
    @IBOutlet weak var bigParentView: UIView!
    
    @IBOutlet weak var smallParentView: UIView!
    override func awakeFromNib() {
        self.coinNameLable.sizeToFit()
        self.balancelable.adjustsFontSizeToFitWidth = true
        self.balanceSmallLable.adjustsFontSizeToFitWidth = true
        self.symbolSmallLable.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.delegate?.didPressSend()
    }
    @IBAction func ReveiceAction(_ sender: Any) {
         self.delegate?.didPressReveice()
    }
    
    
}
