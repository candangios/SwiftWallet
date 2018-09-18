//
//  Lock.swift
//  TomoWallet
//
//  Created by TomoChain on 9/17/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import SAMKeychain
import KeychainSwift
protocol LockInterface {
    func isPasscodeSet() -> Bool
    func shouldShowProtection() -> Bool
}
enum LockType {
    case UnlockWallet
    case AcceptTransfer
}
final class Lock: LockInterface{
    private struct Keys {
        static let service = "tomo.lock"
        static let account = "tomo.account"
    }
    
    private let passcodeAttempts = "passcodeAttempts"
    private let maxAttemptTime = "maxAttemptTime"
    private let autoLockType = "autoLockType"
    private let autoLockTime = "autoLockTime"
    private let keychain = KeychainSwift(keyPrefix: Constants.keychainKeyPrefix)
    
    
    // MARK - :Passcode
    func setPasscode(passcode: String) {
        SAMKeychain.setPassword(passcode, forService: Keys.service, account: Keys.account)
    }
    func deletePasscode() {
        SAMKeychain.deletePassword(forService: Keys.service, account: Keys.account)
//        resetPasscodeAttemptHistory()
//        setAutoLockType(type: AutoLock.immediate)
    }
    
    func isPasscodeSet() -> Bool {
        return  currentPasscode() != nil
    }
    
    func shouldShowProtection() -> Bool {
        return true
    }
    
    func currentPasscode() -> String? {
        return SAMKeychain.password(forService: Keys.service, account: Keys.account)
    }
    
    func isPasscodeValid(passcode: String) -> Bool {
        return passcode == currentPasscode()
    }
    
    
    func numberOfAttempts() -> Int {
        guard let attempts = keychain.get(passcodeAttempts) else {
            return 0
        }
        return Int(attempts)!
    }
    
    func clear() {
        deletePasscode()
//        resetPasscodeAttemptHistory()
//        removeIncorrectMaxAttemptTime()
//        removeAutoLockTime()
    }
    
    
}
