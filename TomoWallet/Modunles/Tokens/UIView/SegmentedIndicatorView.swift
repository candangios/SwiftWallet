//
//  SegmentedIndicatorView.swift
//  TomoWallet
//
//  Created by TomoChain on 8/30/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class SegmentedIndicatorView: UIView {
    let currentPage = 0
    @IBOutlet weak var viewIndicator: UIView!
    @IBOutlet weak var allTransactionsButton: UIButton!
    @IBOutlet weak var receiveTransactionsButton: UIButton!
    @IBOutlet weak var sendTransactionsButton: UIButton!
    var didSelectedPage:((TransactionsPageViewType)->Void)?

    @IBAction func seletedPageTypeAction(_ sender: UIButton) {
        self.didSelectedPage?(TransactionsPageViewType(rawValue: sender.tag)!)
        
    }
    
    func pageViewScrollingProgress(progress: CGFloat, currentPage: TransactionsPageViewType)  {
        switch currentPage{
        case .All:
            if progress <= 0{
                viewIndicator.center.x = allTransactionsButton.center.x
                viewIndicator.bounds.size.width = allTransactionsButton.bounds.width
                return
            }else{
                let distance = receiveTransactionsButton.center.x - allTransactionsButton.center.x
                viewIndicator.center.x = allTransactionsButton.center.x + (distance * progress)
                let scaleWidth = receiveTransactionsButton.bounds.size.width - allTransactionsButton.bounds.size.width
                viewIndicator.bounds.size.width = allTransactionsButton.bounds.size.width + (scaleWidth * progress)
            }
        case .Received:
            if progress == 0{
                viewIndicator.center.x = receiveTransactionsButton.center.x
                viewIndicator.bounds.size.width = receiveTransactionsButton.bounds.width
                return
            }else if progress < 0{
                let distance = receiveTransactionsButton.center.x - allTransactionsButton.center.x
                viewIndicator.center.x = receiveTransactionsButton.center.x + (distance * progress)
                let scaleWidth = receiveTransactionsButton.bounds.size.width - allTransactionsButton.bounds.size.width
                viewIndicator.bounds.size.width = receiveTransactionsButton.bounds.size.width + (scaleWidth * progress)
            }else{
                let distance = sendTransactionsButton.center.x - receiveTransactionsButton.center.x
                viewIndicator.center.x = receiveTransactionsButton.center.x + (distance * progress)
                let scaleWidth = sendTransactionsButton.bounds.size.width - receiveTransactionsButton.bounds.size.width
                viewIndicator.bounds.size.width = receiveTransactionsButton.bounds.size.width + (scaleWidth * progress)
            }
        
        case .Sent:
            if progress >= 0{
                viewIndicator.center.x = sendTransactionsButton.center.x
                viewIndicator.bounds.size.width = sendTransactionsButton.bounds.width
                return
            }else{
                let distance = sendTransactionsButton.center.x - receiveTransactionsButton.center.x
                viewIndicator.center.x = sendTransactionsButton.center.x + (distance * progress)
                let scaleWidth = sendTransactionsButton.bounds.size.width - receiveTransactionsButton.bounds.size.width
                viewIndicator.bounds.size.width = sendTransactionsButton.bounds.size.width + (scaleWidth * progress)
            }
        default:
            break
        }

    }
}
