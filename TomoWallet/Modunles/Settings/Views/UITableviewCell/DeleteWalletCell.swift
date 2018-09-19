//
//  DeleteWalletCell.swift
//  TomoWallet
//
//  Created by TomoChain on 9/19/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class DeleteWalletCell: UITableViewCell {
    static let identifier = "DeleteWalletCell"
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    var onPush:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let touch = UITapGestureRecognizer(target: self, action: #selector(self.didSelected))
        self.addGestureRecognizer(touch)
    }
    @objc private func didSelected() {
        self.onPush?()
    }
    
    func setCell(title: String, image: UIImage) {
        iconImageView.image = image
        titleLable.text = title
       
    }
}
