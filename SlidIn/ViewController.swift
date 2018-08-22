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
       
        SlidInView.leakDirection = .bottom
        
        
        SlidInView.centerAlignOffSet = 100
        bottomView.offSet =  0
       // bottomView.centerAlignOffSet = 20
        
        
       // bottomView.leakDirection = .bottom
        //self.view.addSubview(bottomView)
        self.view.addSubview(SlidInView)
    }

   
    @IBAction func Action(_ sender: Any) {
        SlidInView.PushView(Push:false)
        //bottomView.PushView(Push:false)
    }
    
    @IBAction func hide(_ sender: Any) {
        
        SlidInView.PushView(Push:true)
        //bottomView.PushView(Push:true)
    }
}

