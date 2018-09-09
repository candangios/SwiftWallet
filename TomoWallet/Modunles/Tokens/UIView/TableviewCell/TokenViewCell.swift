 //
//  TokenViewCell.swift
//  TomoWallet
//
//  Created by TomoChain on 8/17/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import Kingfisher

class TokenViewCell: UITableViewCell {
    static let identifier = "TokenViewCell"

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var tokenNameLable: UILabel!
    @IBOutlet weak var tokenSymbolLable: UILabel!
    @IBOutlet weak var amountLable: UILabel!
    @IBOutlet weak var currencyAmountLabel: UILabel!
    @IBOutlet weak var marketPercentageChangeLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(viewModel: TokenViewCellViewModel) {
        
        
        tokenNameLable.text = viewModel.title
        amountLable.text = viewModel.amount
        tokenSymbolLable.text = viewModel.symbol
//        marketPriceLable.text = viewModel.marketPrice
//        marketPercentageChangeLable.text = viewModel.percentChange
        currencyAmountLabel.text = viewModel.currencyAmount
        logoImage.kf.setImage(
            with: viewModel.imageURL,
            placeholder: viewModel.placeholderImage
        )

//        observePendingTransactions(from: viewModel.store, with: viewModel.viewModel.token)
    }
    
}
