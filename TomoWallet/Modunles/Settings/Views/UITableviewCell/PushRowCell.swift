//
//  PushRowCell.swift
//  TomoWallet
//
//  Created by TomoChain on 9/18/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class PushRowCell: UITableViewCell {
    static let identifier = "PushRowCell"
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var highlightView: UIView!
    var onPush:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        highlightView.layer.cornerRadius = 5
        // Initialization code
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.didSelected))
        self.addGestureRecognizer(touch)
    }
    @objc private func didSelected() {
        self.onPush?()
    }
    
    func setCell(title: String, image: UIImage, isHighlight: Bool) {
        iconImageView.image = image
        titleLable.text = title
        highlightView.isHidden = !isHighlight
    }



    
}
