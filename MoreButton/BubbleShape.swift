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
            guard let items = items  else { return }
            
            var width: CGFloat = 0
            
            for i in 0..<items.count {
                width += items[i].imageView?.image?.size.width ?? 0
            }

            widthAnchor.constraint(equalToConstant: spaceBetweenItem * CGFloat(items.count) + width).isActive = true
        }
    }
    
    fileprivate var spaceBetweenItem: CGFloat = 20

    fileprivate lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.0).cgColor
        shapeLayer.frame = bounds
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
        shadowLayer.frame = bounds

        return shadowLayer
    }()

    open func animateDisappearance() {
        guard let items = items else { return }

        let scale: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 0
        scale.duration = 0.5
        scale.fillMode = kCAFillModeForwards
        scale.isRemovedOnCompletion = false
        scale.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)

        
        shapeLayer.removeAllAnimations()
        shadowLayer.removeAllAnimations()
        shadowLayer.add(scale, forKey: scale.keyPath)
        shapeLayer.add(scale, forKey: scale.keyPath)

        for item in items {
            item.removeFromSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.isHidden = true
        })
    }

    open func animateAppearance() {
        guard let items = items else { return }

        let scale: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0
        scale.toValue = 1
        scale.duration = 0.5
        scale.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 0.99)
        isHidden = false

        if layer.sublayers == nil {
            layer.insertSublayer(shadowLayer, at: 0)
            layer.insertSublayer(shapeLayer, at: 1)
        }

        for item in items {
            addSubview(item)
        }

        shadowLayer.add(scale, forKey: scale.keyPath)
        shapeLayer.add(scale, forKey: scale.keyPath)


        // constraint for first item
        items[0].centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addConstraint(NSLayoutConstraint(item: items[0],
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .left,
                                              multiplier: 1,
                                              constant: 10))
        // constraint for the rest of items
        for i in 1..<items.count {
            items[i].centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            addConstraint(NSLayoutConstraint(item: items[i],
                                                  attribute: .leftMargin,
                                                  relatedBy: .equal,
                                                  toItem: items[i-1],
                                                  attribute: .leftMargin,
                                                  multiplier: 1,
                                                  constant: (items[i-1].imageView?.image?.size.width ?? 0) + spaceBetweenItem))
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
