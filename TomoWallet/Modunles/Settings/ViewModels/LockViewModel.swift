//
//  LockViewModel.swift
//  TomoWallet
//
//  Created by TomoChain on 9/18/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
class LockViewModel {
    private let lock = Lock()
    func charCount() -> Int {
        return 6
    }
    func passcodeAttemptLimit() -> Int {
        //If max attempt limit is rached we should give only 1 attempt.
        return 1
//        return lock.incorrectMaxAttemptTimeIsSet() ? 1 : 5
    }
}
