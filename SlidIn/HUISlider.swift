//
//  HUISlider.swift
//  SlidIn
//
//  Created by Lieng Hongky on 10/10/18.
//  Copyright © 2018 Lieng Hongky. All rights reserved.
//

import UIKit

protocol HUISliderDeleget {
    func didDragging(location :CGPoint)
}


class HUISlider: UIControl {
    
    
    
    @IBInspectable var MinHeight:CGFloat=30.0{
        didSet{
            minHeight = MinHeight
        }
    }
    @IBInspectable var MaxHeight:CGFloat=300.0{
        didSet{
            maxHeight = MaxHeight
        }
    }
    private var minHeight:CGFloat = 40
    private var maxHeight:CGFloat = 300
    private var startLocation:CGPoint? = nil
    
    
    var deleget:HUISliderDeleget?
    var viewController:UIViewController!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        initial()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initial()
    }
    func initial() {

    }
    
    
    func initialFrame(){
        minHeight = 40
        maxHeight = 300
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        let location = touch.location(in: self)
     self.deleget?.didDragging(location:location)
        
        let dragLength = location.y - self.frame.height 
        self.frame.size.height += dragLength

        
        
        if self.frame.size.height < minHeight {
            self.frame.size.height = minHeight
        }
        if self.frame.size.height > maxHeight {
            self.frame.size.height = maxHeight
        }
        return true
    }

}

/*
extension HUISlider:HUISliderDeleget{
    func didDragging(location: CGPoint) {
        self.frame.size.height += location.y - self.frame.height
        self.thumbView.frame.origin.y = self.bounds.maxY-30
        self.thumbView.center.x = self.center.x
        if self.frame.size.height < minHeight {
            self.frame.size.height = minHeight
            self.thumbView.frame.origin.y = self.bounds.maxY-30
            self.thumbView.center.x = self.center.x
        }
        if self.frame.size.height > maxHeight {
            self.frame.size.height = maxHeight
            self.thumbView.frame.origin.y = self.bounds.maxY-30
            self.thumbView.center.x = self.center.x
        }
    }
    
}

class HUISliderThumb:UIControl{
    var deleget:HUISliderDeleget?
    var viewController:UIViewController!

}
*/
