//
//  WordPhraseView.swift
//  TomoWallet
//
//  Created by Admin on 9/2/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class WordPhraseView: UIView {
    @IBOutlet weak var wordPhraseLable: UILabel!
    @IBOutlet weak var ordinalNumberLable: UILabel!
   

    func setView(wordPhrase: String, ordinalNumber: String) {
        self.wordPhraseLable.text = wordPhrase
        self.ordinalNumberLable.text = "\(ordinalNumber)."
    }
}
