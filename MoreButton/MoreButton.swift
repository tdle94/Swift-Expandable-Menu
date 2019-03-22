//
//  MoreButton.swift
//  MoreButtonDemo
//
//  Created by Tuyen Le on 15.03.19.
//  Copyright © 2019 Tuyen Le. All rights reserved.
//

import UIKit

class MoreButton: UIButton {

    // MARK: - MoreButton properties
    public private(set) var displayMore: Bool = false

    open lazy private(set) var bubbleShape: BubbleShape = BubbleShape()

    fileprivate var bubbleShapeBottomAnchor: NSLayoutConstraint!

    fileprivate lazy var plusSign: UIBezierPath = {
        let plusSign: UIBezierPath = UIBezierPath()
        plusSign.move(to: CGPoint(x: bounds.midX/2, y: bounds.midY))
        plusSign.addLine(to: CGPoint(x: bounds.maxX - bounds.midX/2, y: bounds.midY))
        plusSign.move(to: CGPoint(x: bounds.midX, y: bounds.midY/2))
        plusSign.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY - bounds.midY/2))
        return plusSign
    }()

    fileprivate lazy var plusSignLayer: CAShapeLayer = {
        let plusSignLayer: CAShapeLayer = CAShapeLayer()
        plusSignLayer.path = plusSign.cgPath
        plusSignLayer.strokeColor = UIColor.black.cgColor
        plusSignLayer.frame = CGRect(x: 0, y: 0, width: bounds.width/2, height: bounds.height/2)
        return plusSignLayer
    }()

    fileprivate lazy var shadowLayer: CAShapeLayer = {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.shadowRadius = 2

        return shadowLayer
    }()

    open func pulsate() {
        shadowLayer.removeAnimation(forKey: "pulsate")
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        shadowLayer.add(pulse, forKey: "pulsate")
    }

    open func animatePlusSign() {
        if displayMore {
            let rotatePlusSign: CGAffineTransform = CGAffineTransform(translationX: plusSignLayer.bounds.width,
                                                                      y: 0).rotated(by: .pi/2)

            plusSignLayer.transform = CATransform3DMakeAffineTransform(rotatePlusSign)

    
            UIView.animate(withDuration: 0.5) {
                self.bubbleShapeBottomAnchor.constant = 0
                self.bubbleShape.animateDisappearance()
                self.layoutIfNeeded()
            }
        } else {
            let rotatePlusSign: CGAffineTransform = CGAffineTransform(translationX: plusSignLayer.bounds.width/2,
                                                                      y: -plusSignLayer.bounds.height/5).rotated(by: .pi/4)

            plusSignLayer.transform = CATransform3DMakeAffineTransform(rotatePlusSign)

            UIView.animate(withDuration: 0.5) {
                self.bubbleShapeBottomAnchor.constant = -self.bounds.height*1.5
                self.bubbleShape.animateAppearance()
                self.layoutIfNeeded()
            }
        }
        self.pulsate()
        self.displayMore = !self.displayMore
    }

    @objc func onTap() {
        self.animatePlusSign()
    }

    // MARK: - override funcs
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.insertSublayer(self.shadowLayer, at: 0)
        self.layer.insertSublayer(self.plusSignLayer, at: 1)
        self.insertSubview(self.bubbleShape, at: 0)

        self.bubbleShape.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.bubbleShapeBottomAnchor = bubbleShape.bottomAnchor.constraint(equalTo: bottomAnchor)
        self.bubbleShapeBottomAnchor.isActive = true
        self.bubbleShape.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        self.addTarget(self, action: #selector(self.onTap), for: UIControlEvents.touchUpInside)
    }

    /// need to detect tap of bubbleShape, which is outside the bound of its superview MoreButton
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside: Bool = super.point(inside: point, with: event)
        let bubbleShapeSpace: CGPoint = self.convert(point, to: self.bubbleShape)
        if bubbleShapeSpace.x > bubbleShape.bounds.minX && bubbleShapeSpace.x < bubbleShape.bounds.maxX
            && bubbleShapeSpace.y > bubbleShape.bounds.minY && bubbleShapeSpace.y < bubbleShape.bounds.maxY {
            return true
        }
        return isInside
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
