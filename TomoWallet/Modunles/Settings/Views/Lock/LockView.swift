//
//  LockView.swift
//  TomoWallet
//
//  Created by TomoChain on 9/18/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import UIKit
final class LockView: UIView{
    var characterView = UIStackView()
    var lockTitle = UILabel()
    var quantity: Int = 0
    var characters: [PasscodeCharacterView]!
    init(_ quantity: Int) {
        super.init(frame: CGRect.zero)
        self.quantity = quantity
        self.characters = passcodeCharacters()
        configCharacterView()
        configLabel()
        addUiElements()
        applyConstraints()
    }
    private func configCharacterView() {
        characterView = UIStackView(arrangedSubviews: self.characters)
        characterView.axis = .horizontal
        characterView.distribution = .fillEqually
        characterView.alignment = .fill
        characterView.spacing = 20
        characterView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func configLabel() {
        lockTitle.font = UIFont.systemFont(ofSize: 30)
        lockTitle.textColor = .white
        lockTitle.textAlignment = .center
        lockTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    private func applyConstraints() {
        lockTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lockTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lockTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 75).isActive = true
        lockTitle.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
    
        characterView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        characterView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        characterView.topAnchor.constraint(equalTo: lockTitle.bottomAnchor, constant: 43).isActive = true
    }
    private func addUiElements() {
        self.backgroundColor = UIColor.white
        self.addSubview(lockTitle)
        self.addSubview(characterView)
    }
    private func passcodeCharacters() -> [PasscodeCharacterView] {
        var characters = [PasscodeCharacterView]()
        for _ in 0..<quantity {
            let passcodeCharacterView = PasscodeCharacterView()
            passcodeCharacterView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            passcodeCharacterView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            characters.append(passcodeCharacterView)
        }
        return characters
    }
    func shake() {
        let keypath = "position"
        let animation = CABasicAnimation(keyPath: keypath)
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: characterView.center.x - 10, y: characterView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: characterView.center.x + 10, y: characterView.center.y))
        characterView.layer.add(animation, forKey: keypath)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
