//
//  ConfigGasPriceView.swift
//  TomoWallet
//
//  Created by TomoChain on 8/24/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import BigInt

enum ConfigGasPriceViewType {
    case Slow
    case Medium
    case Fast
}

class ConfigGasPriceView: UIView {
    var didSeleted: ((_ newGasPrice: BigInt ) -> Void)?
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var slowLable: UILabel!
    @IBOutlet weak var mediumLable: UILabel!
    @IBOutlet weak var fastLable: UILabel!
    let selectedColor = UIColor(hex: "00A7FF")
    let nomalColor = UIColor(hex: "333333")
    
    var gasPrice: BigInt!
    var type: ConfigGasPriceViewType = .Slow {
        didSet{
            switch type {
            case .Slow:
                slowButton.isSelected = true
                mediumButton.isSelected = false
                fastButton.isSelected = false
                slowLable.textColor = selectedColor
                mediumLable.textColor = nomalColor
                fastLable.textColor = nomalColor
            case .Medium:
                slowButton.isSelected = false
                mediumButton.isSelected = true
                fastButton.isSelected = false
                slowLable.textColor = nomalColor
                mediumLable.textColor = selectedColor
                fastLable.textColor = nomalColor
            case .Fast:
                slowButton.isSelected = false
                mediumButton.isSelected = false
                fastButton.isSelected = true
                slowLable.textColor = nomalColor
                mediumLable.textColor = nomalColor
                fastLable.textColor = selectedColor
            }
        }
    }
    func reloaView(gasPrice: BigInt)  {
       self.gasPrice = gasPrice
       
        
    }

    @IBAction func selectedTypeAction(_ sender: UIButton) {
   
        switch sender.tag {
        case 1:
            self.type = .Slow
            self.didSeleted?(self.gasPrice)
        case 2:
            self.type = .Medium
            self.didSeleted?(EtherNumberFormatter.full.number(from: "10", units: UnitConfiguration.gasPriceUnit)!)
        case 3:
            self.type = .Fast
            self.didSeleted?(EtherNumberFormatter.full.number(from: "20", units: UnitConfiguration.gasPriceUnit)!)
        default:
            return
        }
      
    }
    

    
}
