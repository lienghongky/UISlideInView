//
//  ViewController.swift
//  SlidIn
//
//  Created by Lieng Hongky on 8/19/18.
//  Copyright © 2018 Lieng Hongky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
   
    @IBOutlet weak var Dragview: UIView!
    @IBOutlet var bottomView: UISlideInView!
    @IBOutlet weak var container: HUISlider!
    @IBOutlet var SlidInView: UISlideInView!
    var isIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        SlidInView.leakDirection = .top
        
//        SlidInView.HideOffSet = -100
//        SlidInView.ShowOffSet = 100
        
        SlidInView.centerAlignOffSet = 100
        self.view.addSubview(SlidInView)
        
    
        container.viewController = self
        Dragview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action:  #selector(panAction(sender:))))
        
        
    }
   var startLocation:CGPoint? = nil
    @objc func panAction(sender:UIPanGestureRecognizer){
       
        switch sender.state {
        case .began:
            let location = sender.location(in: view)
            startLocation = CGPoint(x: location.x, y: location.y+(container.bounds.maxY - location.y))
            print("sta :", sender.location(in: self.view))
            break
        case .changed:
        
            print("cha :", (startLocation!.y - sender.location(in: self.view).y))
            container.frame.size.height -= sender.translation(in: self.view).y
            break
        case .ended:
            print("end :", sender.location(in: self.view))
            break
        default:
            
            break
        }
    }
    @IBAction func Action(_ sender: Any) {
        SlidInView.PushView(Push:false)
    }
    
    @IBAction func hide(_ sender: Any) {
        SlidInView.PushView(Push: true)
    }
    override func viewWillLayoutSubviews() {
        SlidInView.setUpView()
    }

}

