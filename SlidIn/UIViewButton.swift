//
//  UIViewButton.swift
//  Jongnhams
//
//  Created by PLAN-B   CB on 2018/06/05.
//  Copyright © 2018 Sengthai. All rights reserved.
//

import UIKit

class UIViewButton: UIControl,UIGestureRecognizerDelegate{
    

 
    @IBInspectable var CornerRadius:CGFloat = 0{
        didSet{
            layer.cornerRadius = CornerRadius
        }
    }
    @IBInspectable var ShadowOffset:CGSize = CGSize(width: 0, height: 0){
        didSet{
            layer.shadowOffset = ShadowOffset
        }
    }
    @IBInspectable var ShadowRadius:CGFloat = 0{
        didSet{
            layer.shadowRadius = ShadowRadius
        }
    }
    @IBInspectable var ShadowOpacity:Float = 1{
        didSet{
            layer.shadowOpacity = ShadowOpacity
        }
    }
    @IBInspectable var ShadowColor:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
        didSet{
            layer.shadowColor = ShadowColor.cgColor
        }
    }
    @IBInspectable var BorderColor:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
        didSet{
            layer.borderColor = BorderColor.cgColor
        }
    }
    @IBInspectable var BorderWidth:CGFloat = 0.0{
        didSet{
            layer.borderWidth = BorderWidth
        }
    }

   
    var dim:UIView?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    override func awakeFromNib() {
        initialDim()
    }
    func initialDim(){
        dim = (dim == nil) ? UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)) : dim
       dim?.layer.cornerRadius = CornerRadius
       dim?.backgroundColor = UIColor.clear
       self.addSubview(dim!)
       dim?.center = CGPoint(x: bounds.midX, y: bounds.midY)
     
    }
    
    func addTarget( Target:Any?, action: Selector){
        self.addGestureRecognizer(UITapGestureRecognizer(target: Target, action: action))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changedState()
       
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        identityState()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        identityState()
    }
    func identityState(){
        UIView.animate(withDuration: 0.2, animations: {
            self.dim?.layer.transform = CATransform3DIdentity
            self.dim?.backgroundColor = #colorLiteral(red: 0.1462960025, green: 0.1462960025, blue: 0.1462960025, alpha: 0.3)
            
        }) { (t) in
            self.dim?.backgroundColor = UIColor.clear
            self.dim?.layer.cornerRadius = 0
        }
    }
    func changedState(){
        let transform = CATransform3DScale(CATransform3DIdentity, 0.2 ,(dim?.frame.width)! * 0.2/(dim?.frame.height)!, 0)
        dim?.layer.transform = transform
        dim?.layer.cornerRadius = (dim?.frame.width)! / 2
        dim!.backgroundColor = UIColor.clear
        addSubview(dim!)
        dim?.layer.masksToBounds = true
       
        UIView.animate(withDuration: 0.2, animations: {
            self.dim?.layer.transform = CATransform3DIdentity
            self.dim?.backgroundColor = #colorLiteral(red: 0.1462960025, green: 0.1462960025, blue: 0.1462960025, alpha: 0.2456389127)
            
        }) { (t) in
          self.dim?.layer.cornerRadius = self.CornerRadius
        }
    }
    
}
