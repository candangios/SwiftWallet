//
//  NumberPageView.swift
//  TomoWallet
//
//  Created by TomoChain on 9/18/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import UIKit
enum NumberType {
    case value
    case clear
    case dropLast
}
class NumberPageView: UIView {
    var onchange:((_ type: NumberType,_ value: Int?)->Void)?
    
    @IBAction func getValueFromNumber(_ sender: CalculatorButton) {
        
        switch sender.tag {
        case 10:
            self.onchange?(.dropLast, nil)
        case 11:
            self.onchange?(.clear, nil)
        default:
            self.onchange?(.value, sender.tag)
        }
    }
}
