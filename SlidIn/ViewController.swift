//
//  ViewController.swift
//  SlidIn
//
//  Created by Lieng Hongky on 8/19/18.
//  Copyright © 2018 Lieng Hongky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var bottomView: UISlidInView!
    @IBOutlet var SlidInView: UISlidInView!
    var isIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SlidInView.offSet = 10
        SlidInView.offSet = 10
        SlidInView.leakDirection = .left
        bottomView.offSet = 10
        bottomView.centerAlignOffSet = 300
        
        bottomView.leakDirection = .right
    }

   
    @IBAction func Action(_ sender: Any) {
        SlidInView.PushView()
        bottomView.PushView(animationOption: UIViewAnimationOptions.curveEaseIn)
    }
    
}

