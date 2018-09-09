//
//  VerifyPassphraseVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/16/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import Foundation
import TrustKeystore
protocol VerifyPassphraseVC_Delegate:class {
    func didFinish(in controller: VerifyPassphraseVC, with account: Wallet)
    func didSkip(in controller: VerifyPassphraseVC, with account: Wallet)
}
class MyTapGesture: UITapGestureRecognizer {
    var tag = Int()
}

class VerifyPassphraseVC: BaseViewController {
    let account: Wallet
    let words: [String]
    let shuffledWords: [String]
    var proccesWords: [String]
    let mode: PassphraseMode
    weak var delegate: VerifyPassphraseVC_Delegate?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var proposalView: UIView!
    
    init(account: Wallet, words:[String], mode: PassphraseMode) {
        self.account = account
        self.words = words
        self.mode = mode
        self.shuffledWords = words.shuffled()
        self.proccesWords = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setProposalView()
        setContenView()

        // Do any additional setup after loading the view.
    }
    func setContenView() {
        let width = UIScreen.main.bounds.width/3
        for index in 0..<self.words.count {
            guard let view = Bundle.main.loadNibNamed("VeryfyWordPhraseView", owner: nil, options: nil)?.first as? VeryfyWordPhraseView else{
                return
            }
            view.ordinalNumberLable.font = UIFont.systemFont(ofSize: 16)
            view.wordPhraseLable.font = UIFont.boldSystemFont(ofSize: 16)
            view.tag = index
            if index < 4{
                view.frame = CGRect(x: 0, y: index * 34, width: Int(width), height: 34)
            }else if(3 < index && index < 8){
                 view.frame = CGRect(x: Int(width), y: (index - 4) * 34, width: Int(width), height: 34)
            }
            else{
                view.frame = CGRect(x: Int(width*2), y: (index - 8) * 34, width: Int(width), height: 34)
            }
            view.setView(wordPhrase: "", ordinalNumber: "\(index + 1)")
            let tap = MyTapGesture(target: self, action: #selector(self.unselectedWord(sender:)))
            tap.tag = index
                view.addGestureRecognizer(tap)
            self.contentView.addSubview(view)
        }
    }
    
    func refeshContentView() {
        
        for index in 0..<self.proccesWords.count {
            if let view = self.contentView.viewWithTag(index) as? VeryfyWordPhraseView {
                view.wordPhraseLable.text = proccesWords[index]
            }
        }
        for index in self.proccesWords.count...12 {
            if let view = self.contentView.viewWithTag(index) as? VeryfyWordPhraseView {
                view.wordPhraseLable.text = ""
            }
        }
        
    }
    
    func setProposalView() {
        for index in 0..<self.shuffledWords.count {
            if let button = self.proposalView.viewWithTag(index) as? UIButton {
                button.setTitle(shuffledWords[index], for: .normal)
                button.addTarget(self, action: #selector(self.selectedWord(sender:)), for: .touchUpInside)
            }
        }
    }
    
    @objc func selectedWord(sender: UIButton) {
        sender.isHidden = true
        let word = self.shuffledWords[sender.tag]
        self.proccesWords.append(word)
        self.refeshContentView()
    }
    @objc func unselectedWord(sender: MyTapGesture) {
        let tag = sender.tag
    
        if tag >= self.proccesWords.count {return}
        let word = self.proccesWords[tag]
        self.proccesWords.remove(at: tag)
        self.refeshContentView()
        if let tag = self.shuffledWords.index(of: word){
            if let button = self.proposalView.viewWithTag(tag) as? UIButton {
                button.isHidden = false
            }
        }
    }


}
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 3.2
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


