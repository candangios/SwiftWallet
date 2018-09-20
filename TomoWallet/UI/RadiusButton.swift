//
//  RadiusButton.swift
//  TomoWallet
//
//  Created by TomoChain on 9/7/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class RadiusButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height/2
        self.imageEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        self.imageView?.contentMode = .scaleAspectFit
    }
//    override func setNeedsLayout() {
//        self.layer.cornerRadius = self.frame.height/2
//    }
}
