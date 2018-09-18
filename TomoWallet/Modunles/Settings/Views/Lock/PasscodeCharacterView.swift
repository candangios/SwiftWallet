//
//  PasscodeCharacterView.swift
//  TomoWallet
//
//  Created by TomoChain on 9/18/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

class PasscodeCharacterView: UIView {
    var isEmpty = true
    private var circleFill: CAShapeLayer?
    private var circle: CAShapeLayer?
    override func layoutSubviews() {
        commonInit()
    }
    private func commonInit() {
        isEmpty = true
        backgroundColor = UIColor.clear
        drawCircleFill()
        drawCircle()
        redraw()
    }
    private func redraw() {
        circleFill?.isHidden = isEmpty
        circle?.isHidden = !isEmpty
    }
    private func drawCircleFill() {
        let borderWidth: CGFloat = 1
        let radius: CGFloat = bounds.width / 2 - borderWidth
        let circle = CAShapeLayer()
        circle.path = UIBezierPath(roundedRect: CGRect(x: borderWidth, y: borderWidth, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
        let circleColor: UIColor? = UIColor.white
        circle.fillColor = circleColor?.cgColor
        circle.strokeColor = circleColor?.cgColor
        circle.borderWidth = borderWidth
        layer.addSublayer(circle)
        self.circleFill = circle
    }
    private func drawCircle() {
        let borderWidth: CGFloat = 1
        let radius: CGFloat = bounds.width / 2 - borderWidth
        let circle = CAShapeLayer()
        circle.path = UIBezierPath(roundedRect: CGRect(x: borderWidth, y: borderWidth, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
        let circleColor: UIColor? = UIColor.white
        circle.strokeColor = circleColor?.cgColor
        circle.borderWidth = borderWidth
        layer.addSublayer(circle)
        self.circle = circle
    }
    func setEmpty(_ isEmpty: Bool) {
        if self.isEmpty != isEmpty {
            self.isEmpty = isEmpty
            redraw()
        }
    }


}
