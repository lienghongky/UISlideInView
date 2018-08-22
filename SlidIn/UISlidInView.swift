//
//  SliderInUtil.swift
//  TingTing
//
//  Created by Lieng Hongky on 8/19/18.
//  Copyright © 2018 Lieng Hongky. All rights reserved.
//

import Foundation
import UIKit
class UISlidInView:UIView{
    
    var ShouldHidden:Bool = false{
        didSet{
            UIApplication.shared.keyWindow?.addSubview(self)
            self.frame.origin = CGPoint(x: 0, y: -self.frame.height)
            UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.frame.origin = CGPoint(x: 0, y:0)
            }, completion: nil)
        }
    }
    
   
}
