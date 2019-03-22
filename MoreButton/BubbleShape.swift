//
//  MoreContainer.swift
//  MoreButtonDemo
//
//  Created by Tuyen Le on 16.03.19.
//  Copyright © 2019 Tuyen Le. All rights reserved.
//

import UIKit

class BubbleShape: UIView {
    open var items: [BubbleShapeItem]? {
        didSet {
            guard items != nil else { return }
            guard let moreButton = superview as? MoreButton else { return }
            
            widthAnchor.constraint(equalToConstant: CGFloat(items!.count) * moreButton.bounds.width).isActive = true
        }
    }

    fileprivate lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.path = self.path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.0).cgColor
        shapeLayer.frame = self.bounds
        return shapeLayer
    }()

    fileprivate lazy var path: UIBezierPath = {
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 0))
        path.addQuadCurve(to: CGPoint(x: 0, y: 10), controlPoint: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: bounds.maxY - 10))
        path.addQuadCurve(to: CGPoint(x: bounds.minX + 10, y: bounds.maxY), controlPoint: CGPoint(x: 0, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.midX - 5, y: bounds.maxY))
        path.addQuadCurve(to: CGPoint(x: path.currentPoint.x + 10, y: path.currentPoint.y),
                          controlPoint: CGPoint(x: path.currentPoint.x + 5, y: path.currentPoint.y + 20))
        path.addLine(to: CGPoint(x: bounds.maxX - 10, y: bounds.maxY))
        path.addQuadCurve(to: CGPoint(x: bounds.maxX, y: bounds.maxY - 10),
                          controlPoint: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY + 10))
        path.addQuadCurve(to: CGPoint(x: bounds.maxX - 10, y: 0),
                          controlPoint: CGPoint(x: bounds.maxX, y: 0))
        path.addLine(to: CGPoint(x: 10, y: 0))
        return path
    }()

    fileprivate lazy var shadowLayer: CAShapeLayer = {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = self.path.cgPath
        shadowLayer.fillColor = UIColor(red:0.99, green:0.99, blue:0.99, alpha:1.0).cgColor

        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.shadowRadius = 2
        shadowLayer.frame = self.bounds

        return shadowLayer
    }()

    open func animateDisappearance() {
        guard items != nil else { return }

        let scale: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 0
        scale.duration = 0.5
        scale.fillMode = kCAFillModeForwards
        scale.isRemovedOnCompletion = false
        scale.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)

        
        self.shapeLayer.removeAllAnimations()
        self.shadowLayer.removeAllAnimations()
        self.shadowLayer.add(scale, forKey: scale.keyPath)
        self.shapeLayer.add(scale, forKey: scale.keyPath)

        for item in self.items! {
            item.removeFromSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.isHidden = true
        })
    }

    open func animateAppearance() {
        guard items != nil else { return }

        let scale: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0
        scale.toValue = 1
        scale.duration = 0.5
        scale.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        self.isHidden = false

        if layer.sublayers == nil {
            self.layer.insertSublayer(self.shadowLayer, at: 0)
            self.layer.insertSublayer(self.shapeLayer, at: 1)
        }

        for item in self.items! {
            self.addSubview(item)
        }

        self.shadowLayer.add(scale, forKey: scale.keyPath)
        self.shapeLayer.add(scale, forKey: scale.keyPath)

        
        // constraint for first item
        self.items![0].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.addConstraint(NSLayoutConstraint(item: self.items![0],
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .left,
                                              multiplier: 1,
                                              constant: 0))
        // constraint for the rest of items
        for i in 1..<self.items!.count {
            self.items![i].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            self.addConstraint(NSLayoutConstraint(item: self.items![i],
                                                  attribute: .leftMargin,
                                                  relatedBy: .greaterThanOrEqual,
                                                  toItem: self.items![i-1],
                                                  attribute: .leftMargin,
                                                  multiplier: 1,
                                                  constant: self.items![0].imageView?.image?.size.width ?? 0))
        }

    }

    // MARK: - designate init
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
