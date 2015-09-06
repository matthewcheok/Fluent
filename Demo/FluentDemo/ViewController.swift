//
//  ViewController.swift
//  Fluent
//
//  Created by Matthew Cheok on 4/9/15.
//  Copyright © 2015 Matthew Cheok. All rights reserved.
//

import UIKit
import Fluent

class ViewController: UIViewController {
    let boxView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    var expanded = false
    
    func handleTap(tap: UITapGestureRecognizer) {
//        if expanded {
//            box.animate(1).scaleBy(0.5).rotateBy(-0.5).translateBy(-50, -50).backgroundColor(.redColor())
//            expanded = false
//        }
//        else {
//            box.animate(1).translateBy(50, 50).rotateBy(0.5).scaleBy(2).backgroundColor(.blueColor()).alpha(0.7)
//            expanded = true
//        }

        boxView
            .animate(0.5)
            .rotate(0.5)
            .scale(2)
            .backgroundColor(.blueColor())
            .waitThenAnimate(0.5)
            .scale(1)
            .backgroundColor(.redColor())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        boxView.backgroundColor = .redColor()
        boxView.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        view.addSubview(boxView)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

