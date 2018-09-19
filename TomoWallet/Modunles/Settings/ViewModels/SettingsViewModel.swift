//
//  SettingsViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 9/17/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
struct SettingsViewModel {
    var title: String{
        return "Settings"
    }
    
    var enableNotification: Bool{
        return false
    }
    func setNotification(value: Bool) {
        print(value)
    }
    var enableTouchID: Bool{
        return false
    }
    func setTouchID(value: Bool) {
        print(value)
    }
    func titleForSection(section: Int) -> String? {
        switch section {
        case 0:
            return "ACCOUNT"
        case 1:
            return "SECURITY"
        case 3:
            return "USE PASSCODE OR TOUCH ID FOR"
        case 4:
            return "ABOUT"
        default:
            return .none
        }
    }
    func footerForSection(section: Int) -> String? {
        switch section {
        case 1:
            return "Protect your wallet and confirm your transfer via \nPasscode"
        case 2:
            return "Use Touch ID instead of Passcode for more \nconvenient"
       
        default:
            return .none
        }
    }


    
   
}
