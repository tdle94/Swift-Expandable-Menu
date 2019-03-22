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
                                                              width: 30,
                                                              height: 30))
        moreButton.bubbleShape.items = [
            BubbleShapeItem(title: "alarm", image: UIImage(named: "alarm"), tappedAction: { print("sldkfj") }),
            BubbleShapeItem(title: "music", image: UIImage(named: "music"), tappedAction: { print("sldkfj") }),
            BubbleShapeItem(title: "camera", image: UIImage(named: "camera"), tappedAction: { print("sldkfj") }),
            BubbleShapeItem(title: "camera", image: UIImage(named: "music"), tappedAction: { print("sldkfj") })
        ]
        view.addSubview(moreButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

