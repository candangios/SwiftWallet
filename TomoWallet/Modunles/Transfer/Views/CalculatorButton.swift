//
//  CalculatorButton.swift
//  TomoWallet
//
//  Created by TomoChain on 9/4/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class CalculatorButton: UIButton {
    override func awakeFromNib() {
        self.layer.borderColor = UIColor(hex: "E8E5E5").cgColor
        self.layer.borderWidth = 1
    }
    
    override func setNeedsLayout() {
        self.layer.cornerRadius = self.frame.width/2
    }
  
    

}
