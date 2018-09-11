//
//  TransactionViewCell.swift
//  TomoWallet
//
//  Created by TomoChain on 8/31/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import Lottie

class TransactionViewCell: UITableViewCell {
    static let identifier = "TransactionViewCell"

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.amountLabel.sizeToFit()
        // Initialization code
    }
    func configure(viewModel: TransactionCellViewModel) {
   
        statusView.addSubview(viewModel.statusView ?? UIView())
        
        titleLable.text = viewModel.title
        
        descriptionLable.text = viewModel.subTitle
        
        amountLabel.text = viewModel.amountText
 
        amountLabel.textColor = viewModel.amountTextColor
        
        backgroundColor = viewModel.backgroundColor
    }
}
