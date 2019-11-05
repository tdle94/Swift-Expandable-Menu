//
//  ViewController.swift
//  MoreButton
//
//  Created by Tuyen Le on 15.03.19.
//  Copyright © 2019 Tuyen Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let moreButton: MoreButton = MoreButton(frame: CGRect(x: view.bounds.width/2,
                                                              y: view.bounds.height/2,
                                                              width: 50,
                                                              height: 50))
        moreButton.bubbleShape.frame.size = CGSize(width: 100, height: 80)
        moreButton.bubbleShape.items = [
            BubbleShapeItem(title: "music", image: UIImage(named: "music"), tappedAction: { print("music") }),
            BubbleShapeItem(title: "camera", image: UIImage(named: "camera"), tappedAction: { print("camera") }),
            BubbleShapeItem(title: "alarm", image: UIImage(named: "alarm"), tappedAction: { print("alarm") }),
            BubbleShapeItem(title: "wifi", image: UIImage(named: "wifi"), tappedAction: { print("wifi") })
        ]
        view.addSubview(moreButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

