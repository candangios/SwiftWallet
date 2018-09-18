//
//  SwitchRowCell.swift
//  TomoWallet
//
//  Created by TomoChain on 9/18/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class SwitchRowCell: UITableViewCell {
    static let identifier = "SwitchRowCell"
   
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLable: UILabel!
    
    var onChange:((_ value: Bool)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(title: String, image: UIImage, value: Bool) {
        iconImageView.image = image
        titleLable.text = title
        switchView.isOn = value
    }

    @IBAction func valueChanged(_ sender: UISwitch) {
        self.onChange?(sender.isOn)
    }
  
}
