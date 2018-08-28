//
//  BolderButton.swift
//  TomoWallet
//
//  Created by TomoChain on 8/28/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import UIKit
class BolderButton: UIButton {
    override func awakeFromNib() {
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = self.frame.height/2
    }
    
}
