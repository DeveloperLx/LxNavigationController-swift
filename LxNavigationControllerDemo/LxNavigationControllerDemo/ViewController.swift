//
//  ViewController.swift
//  LxNavigationControllerDemo
//
//  Created by DeveloperLx on 15/7/3.
//  Copyright (c) 2015年 DeveloperLx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = .None
        title = "LxNavigationController"
        view.backgroundColor = UIColor(red: CGFloat(arc4random()) / 0xFFFFFFFF, green: CGFloat(arc4random()) / 0xFFFFFFFF, blue: CGFloat(arc4random()) / 0xFFFFFFFF, alpha: 1)
        
        let pushButton = UIButton.buttonWithType(.Custom) as! UIButton
        pushButton.backgroundColor = UIColor.whiteColor()
        pushButton.setTitle("Push", forState: .Normal)
        pushButton.setTitleColor(view.backgroundColor, forState: .Normal)
        pushButton.addTarget(self, action: "pushButtonClicked:", forControlEvents: .TouchUpInside)
        view.addSubview(pushButton)
        
        pushButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let pushButtonConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[pushButton]-30-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["pushButton" : pushButton])
        let pushButtonConstraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-90-[pushButton(==48)]", options: .DirectionLeadingToTrailing, metrics: nil, views: ["pushButton" : pushButton])
        
        view.addConstraints(pushButtonConstraintsH)
        view.addConstraints(pushButtonConstraintsV)
    }
    
    func pushButtonClicked(btn: UIButton) {
    
        navigationController?.pushViewController(ViewController(), animated: true)
    }


}

