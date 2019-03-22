//
//  BubbleShapeController.swift
//  MoreButtonDemo
//
//  Created by Tuyen Le on 17.03.19.
//  Copyright © 2019 Tuyen Le. All rights reserved.
//

import UIKit

class BubbleShapeItem: UIButton {

    fileprivate var tappedAction: (() -> Void)?

    init(title: String? = nil, image: UIImage? = nil, tappedAction: (() -> Void)?) {
        super.init(frame: .zero)
        self.setImage(image, for: UIControlState.normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.titleLabel?.text = title
        self.clipsToBounds = true
        self.tappedAction = tappedAction
        self.addTarget(self, action: #selector(self.onTap), for: UIControlEvents.touchUpInside)
        self.titleEdgeInsets.left = 100
    }

    @objc fileprivate func onTap() {
        self.tappedAction?()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
