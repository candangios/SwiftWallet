//
//  VeryfyWordPhraseView.swift
//  TomoWallet
//
//  Created by TomoChain on 9/7/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class VeryfyWordPhraseView: UIView {
    @IBOutlet weak var wordPhraseLable: UILabel!
    @IBOutlet weak var ordinalNumberLable: UILabel!
    
    
    func setView(wordPhrase: String, ordinalNumber: String) {
        self.wordPhraseLable.text = wordPhrase
        self.ordinalNumberLable.text = "\(ordinalNumber)."
    }
}
