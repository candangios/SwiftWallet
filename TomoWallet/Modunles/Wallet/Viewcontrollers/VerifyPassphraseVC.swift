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
enum VerifyStatus {
    case empty
    case progress
    case invalid
    case correct
    
    var text: String {
        switch self {
        case .empty, .progress: return ""
        case .invalid: return NSLocalizedString("verify.passphrase.invalidOrder.title", value: "Invalid order. Try again!", comment: "")
        case .correct:
            return String(format: NSLocalizedString("verify.passphrase.welldone.title", value: "Well done! %@", comment: ""), "✅")
        }
    }

    
    static func from(initialWords: [String], progressWords: [String]) -> VerifyStatus {
        guard !progressWords.isEmpty else { return .empty }
        
        if initialWords == progressWords && initialWords.count == progressWords.count {
            return .correct
        }
        
        if progressWords == Array(initialWords.prefix(progressWords.count)) {
            return .progress
        }
        
        return .invalid
    }
}

class VerifyPassphraseVC: BaseViewController {
    let account: Wallet
    let words: [String]
    let shuffledWords: [String]
    var proccesWords: [String]
    let mode: PassphraseMode
    weak var delegate: VerifyPassphraseVC_Delegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var doneButton: UIButton!

    @IBOutlet weak var heightContrain: NSLayoutConstraint!
    
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
        self.scrollView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        let height = UIScreen.main.bounds.height
        if height > 677{
            self.heightContrain.constant = height
        }
        setProposalView()
        setContenView()
        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Close"), style: .plain, target: self, action: #selector(self.didSKipAction))
        self.navigationItem.rightBarButtonItem = closeButton
    }
    @objc func didSKipAction() {
        self.delegate?.didSkip(in: self, with: self.account)
    }
    func setContenView() {
        let width = UIScreen.main.bounds.width/3
 
        for index in 0..<self.words.count {
            guard let view = Bundle.main.loadNibNamed("VeryfyWordPhraseView", owner: nil, options: nil)?.first as? VeryfyWordPhraseView else{
                return
            }
            view.tag = index
            if index < 4{
                view.frame = CGRect(x: 0, y: CGFloat(index * 34), width:CGFloat(width*2), height: 34)
            }else if(3 < index && index < 8){
                 view.frame = CGRect(x: width, y: CGFloat((index - 4) * 34), width: CGFloat(width*2), height: 34)
            }
            else{
                view.frame = CGRect(x: width*2, y: CGFloat((index - 8) * 34), width: CGFloat(width*2), height: 34)
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
            if let button = self.proposalView.viewWithTag(index) as? RadiusButton {
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

    @IBAction func checkAction(_ sender: Any) {
        let status = VerifyStatus.from(initialWords: words, progressWords: proccesWords)
        switch status {
        case .correct:
            self.delegate?.didFinish(in: self, with: self.account)
        default:
            let alert = UIAlertController(title:status.text, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
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


