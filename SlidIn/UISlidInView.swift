//
//  UISlidInView.swift
//  Lieng Hongky free
//
//  Created by Lieng Hongky on 8/19/18.
//  Copyright © 2018 Lieng Hongky. All rights reserved.
//

import Foundation
import UIKit


enum UISlidInViewLeakDirection {
    case bottom,top,left,right
}

class UISlidInView:UIView{
    
    @IBInspectable var ShowOffSet:CGFloat=0.0{
        didSet{
            showOffSet = ShowOffSet
        }
    }
    @IBInspectable var HideOffSet:CGFloat=0.0{
        didSet{
            hideOffSet = HideOffSet
        }
    }
    
    var ViewController:UIViewController?
    var leakDirection:UISlidInViewLeakDirection = .top
    
    var animationOption:UIViewAnimationOptions = .curveEaseInOut
    var duration:TimeInterval = 0.5
    var delay:TimeInterval = 0.0
    var dumping:CGFloat = 0.8
    var initialSpringVelocity:CGFloat = 0.0
    
    var showOffSet:CGFloat = 0
    var hideOffSet:CGFloat = 0
    var centerAlignOffSet:CGFloat = 0
    var offSet:CGFloat = 0{
        didSet{
            hideOffSet = offSet
            showOffSet = offSet
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (t) in
                self.initail()
            }
        }
    }
    var isShowing:Bool{
        get{
            return !isHidding
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    // initail()
    }
    
    
   private var isHidding:Bool = true{
        didSet{
            guard UIApplication.shared.keyWindow != nil else {
                return
            }
          
            let keyWindow = UIApplication.shared.keyWindow!
            //let keyWindow = self.ViewController!.view!
            
            
            var hiddenOrigin:CGPoint!
            var showOringin:CGPoint!

            switch leakDirection {
            case .top:
                hiddenOrigin = CGPoint(x: 0, y: 0 )
                showOringin = CGPoint(x: 0, y: self.frame.height)
                break
            case .bottom:
                hiddenOrigin = CGPoint(x: 0, y:  0)
                showOringin = CGPoint(x: 0, y: -self.frame.height)
                break
            case .left:
                hiddenOrigin = CGPoint(x: 0, y: 0)
                showOringin = CGPoint(x: self.frame.width, y: 0)
                break
            case .right:
                hiddenOrigin = CGPoint(x:0, y: 0)
                showOringin = CGPoint(x: -self.frame.width, y: 0)
                break
            }
            
            let startOrigin:CGPoint = isHidding ? showOringin : hiddenOrigin
            let endOrigin:CGPoint = isHidding ? hiddenOrigin : showOringin
            let startAF = CGAffineTransform(translationX: startOrigin.x, y: startOrigin.y)
            let endAF = CGAffineTransform.init(translationX: endOrigin.x, y: endOrigin.y)
          ///  keyWindow.addSubview(self)
            //self.frame.origin = startOrigin
            self.layer.setAffineTransform(startAF)
            
            switch self.leakDirection{
            case .top , .bottom:
                self.center.x = keyWindow.center.x + centerAlignOffSet
                break
            case .left , .right:
                self.center.y = keyWindow.center.y + centerAlignOffSet
                break
            }
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dumping, initialSpringVelocity: initialSpringVelocity, options: animationOption, animations: {
                self.layer.setAffineTransform(endAF)
                
                
                switch self.leakDirection{
                case .top , .bottom:
                    self.center.x = keyWindow.center.x + self.centerAlignOffSet
                    break
                case .left , .right:
                    self.center.y = keyWindow.center.y + self.centerAlignOffSet
                    break
                }
                
                print(self.frame.origin)
                
            }, completion: nil)
            
        }
    }
    
    func PushView(from direction:UISlidInViewLeakDirection? = nil,
                  Push In:Bool? = nil,
                  duration:TimeInterval?=nil,
                  delay:TimeInterval?=nil,
                  dumping:CGFloat?=nil,
                  initialSpringVelocity:CGFloat?=nil,
                  animationOption:UIViewAnimationOptions?=nil,
                  hideOffSet:CGFloat?=nil,
                  showOffSet:CGFloat?=nil)
    {
        self.duration = duration != nil ? duration! : self.duration
        self.delay = delay != nil ? delay! : self.delay
        self.dumping = dumping != nil ? dumping! : self.dumping
        self.initialSpringVelocity = initialSpringVelocity != nil ? initialSpringVelocity! : self.initialSpringVelocity
        self.animationOption = animationOption != nil ? animationOption! : self.animationOption
        self.leakDirection = direction != nil ? direction! : self.leakDirection
        self.ShowOffSet = showOffSet != nil ? showOffSet! : self.showOffSet
        self.HideOffSet = hideOffSet != nil ? hideOffSet! : self.hideOffSet
        if In != nil && In != isHidding{
            self.isHidding = In!
        }
    }
    func initail(){
        guard UIApplication.shared.keyWindow != nil else {
            return
        }
        let keyWindow = UIApplication.shared.keyWindow!
        
        var hiddenOrigin:CGPoint!
        var showOringin:CGPoint!
        
        
        
        switch leakDirection {
        case .top:
            hiddenOrigin = CGPoint(x: 0, y: hideOffSet - self.frame.height )
            showOringin = CGPoint(x: 0, y: -showOffSet)
            break
        case .bottom:
            hiddenOrigin = CGPoint(x: 0, y:  keyWindow.frame.height - hideOffSet)
            showOringin = CGPoint(x: 0, y: keyWindow.frame.height - self.frame.height - showOffSet )
            break
        case .left:
            hiddenOrigin = CGPoint(x: hideOffSet-self.frame.width, y: 0)
            showOringin = CGPoint(x: showOffSet, y: 0)
            break
        case .right:
            hiddenOrigin = CGPoint(x: keyWindow.frame.width - hideOffSet, y: 0)
            showOringin = CGPoint(x:keyWindow.frame.width - showOffSet - self.frame.width, y: 0)
            break
        }
        
        let startOrigin:CGPoint = isHidding ? hiddenOrigin : showOringin
        //let endOrigin:CGPoint = isHidding ? showOringin : hiddenOrigin
        
        
        // keyWindow.addSubview(self)
        self.frame.origin = startOrigin
        
        switch self.leakDirection{
        case .top , .bottom:
            self.center.x = keyWindow.center.x + centerAlignOffSet
            break
        case .left , .right:
            self.center.y = keyWindow.center.y + centerAlignOffSet
            break
        }
        
    }
}

extension UIApplication{
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
    
}

