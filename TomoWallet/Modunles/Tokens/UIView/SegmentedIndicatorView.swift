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
    @IBOutlet weak var ReceiveTransactionsButton: UIButton!
    @IBOutlet weak var sendTransactionsButton: UIButton!
    
    
    @IBAction func seletedPageTypeAction(_ sender: Any) {
        
        
    }
    
    func pageViewScrollingProgress(progress: CGFloat)  {
//        switch progress {
// 
//        case 0:
//            switch currentPage{
//            case 0:
//                viewIndicator.center.x = allTransactionsButton.center.x
//            case 1:
//                viewIndicator.center.x = ReceiveTransactionsButton.center.x
//            case 2:
//                viewIndicator.center.x = sendTransactionsButton.center.x
//            default:
//                break
//            }
//        default:
//            indicator.center.x = (self.currentPage == 0 ? feedCenterPoint : questionsCenterPoint) + (distance * progress)
//            indicator.bounds.size.width = (self.currentPage == 0 ? feedIndicatorWidth : questionIndicatorWidth) + (scaleWidth * progress)
//        }
    }
}
