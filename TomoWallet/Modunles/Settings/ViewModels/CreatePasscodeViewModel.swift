//
//  CreatePasscodeViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 9/19/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation

class CreatePasscodeViewModel {
    let lock: Lock
    private var passcode: String = ""

    init(lock:Lock) {
        self.lock = lock
    }

    func getPasscode() -> String {
        return passcode
    }

    func savePasscode(passcode: String) {
        lock.setPasscode(passcode: passcode)
    }
    
    func isPasscodeValid(passcode: String) -> Bool {
        if lock.isPasscodeValid(passcode: passcode){
            lock.deletePasscode()
            return true
        }
        return false
    }
    func clear() {
        passcode = ""
    }
    func dropLast() {
        if passcode.count > 0{
           passcode.removeLast()
            print(passcode)
        }
    }
    func newLenght() -> Int {
        return passcode.count
    }
    
    func appendPasscode(code:String){
        if passcode.count > 6 {return}
        passcode.append(code)
      
    }
}
