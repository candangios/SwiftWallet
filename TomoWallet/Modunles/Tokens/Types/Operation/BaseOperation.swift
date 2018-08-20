//
//  BaseOperation.swift
//  TomoWallet
//
//  Created by TomoChain on 8/20/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import UIKit

class BaseOperation: Operation {
    
    enum KVOProperties {
        static let isFinished = "isFinished"
        static let isExecuting = "isExecuting"
    }
    
    private var _finished = false
    private var _isExecuting = false
    
    override public var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: KVOProperties.isFinished)
            _finished = newValue
            didChangeValue(forKey: KVOProperties.isFinished)
        }
    }
    
    override public var isExecuting: Bool {
        get { return _isExecuting }
        set {
            willChangeValue(forKey: KVOProperties.isExecuting)
            _isExecuting = newValue
            didChangeValue(forKey: KVOProperties.isExecuting)
        }
    }
    
    func finish() {
        isExecuting = false
        isFinished = true
    }
    
    override func start() {
        if isCancelled {
            finish()
            
        } else {
            isExecuting = true
            main()
        }
    }
}
