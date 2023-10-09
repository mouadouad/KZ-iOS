//
//  tuto.swift
//  Kz
//
//  Created by mouad ouad on 27/03/2020.
//  Copyright © 2020 mouad ouad. All rights reserved.
//

import UIKit

class tuto: UIViewController {
    
    var page = 0
    var next1: UIButton = UIButton(frame:CGRect(x:0,y:0,width:0,height:0))

    override func viewDidLoad() {
        super.viewDidLoad()


        let img = UIImage(named: "tuto1")
        view.layer.contents = img?.cgImage
        
        next1 = UIButton(frame:CGRect(x:setx(1080-200-100),y:sety(1450),width:setx(200),height:sety(150)))
        next1.setImage(UIImage(named: "next_button"), for:.normal)
        next1.addTarget(self,action :#selector(next_button), for:.touchUpInside)
        self.view.addSubview(next1)
        
        back()
        
        
    }
    
    @objc func next_button(sender: UIButton){
        
        switch page {
        case 0:
            let img = UIImage(named: "tuto2")
            view.layer.contents = img?.cgImage
            page += 1
            
        case 1:
            let img = UIImage(named: "tuto3")
            view.layer.contents = img?.cgImage
            next1.isHidden = true
            
            
        
        default: break
            
        }
        
    }

    func setx(_ size:Int)->Int{
        
        var x:Int
        x=(size*Int(start.width))/1080
        return x
        
    }
      
    func sety(_ size:Int)->Int{
            
            var x:Int
        x=(size*Int(start.height))/1770
            return x
            
        }
    
    func back(){
        
        let back = UIButton(frame:CGRect(x:setx(50),y:sety(50),width:setx(100),height:sety(100)))
        back.setImage(UIImage(named: "back_button"), for:.normal)
        back.addTarget(self,action :#selector(back_button), for:.touchUpInside)
        self.view.addSubview(back)
        
    }
    
    @objc func back_button(sender: UIButton){
        
        self.dismiss(animated: true, completion: nil)
        
    }


}
