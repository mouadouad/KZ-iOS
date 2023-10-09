//
//  Normal.swift
//  Kz
//
//  Created by mouad ouad on 22/03/2020.
//  Copyright © 2020 mouad ouad. All rights reserved.
//

import UIKit

class Normal: UIViewController {
    
    
    var et = UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
    var tv = UITextView(frame:CGRect(x:0,y:0,width:0,height:0))
    var confirm = UIButton(frame:CGRect(x:0,y:0,width:0,height:0))
    var replay = UIButton(frame:CGRect(x:0,y:0,width:0,height:0))
    var a = 0
    var b = 0
    var c = 0
    var d = 0
    var mutableShown = NSMutableAttributedString()
    var s : String = ""
    var line = 0
    var error = false
    var dim = UIView(frame:CGRect(x:0,y:0,width:0,height:0))
    var Msg_box = UIView(frame:CGRect(x:0,y:0,width:0,height:0))
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //SET BACKGROUND COLOR
        view.backgroundColor = UIColor(named: "background_color")
        
        make_keyboard()
        make_editText()
        make_textView()
        make_confirm_buttons()
        generate_randoms()
        back()
        
  
           
        }
    
    func generate_randoms(){
        
        a = Int.random(in: 0...9)
        b = Int.random(in: 0...9)
        c = Int.random(in: 0...9)
        d = Int.random(in: 0...9)
        
        if a==b||a==c||a==d {
            while a==b||a==c||a==d {
                a = Int.random(in: 0...9)
            }
            
        }
        
        if b==c||b==d{
            while b==a||b==c||b==d {
                b = Int.random(in: 0...9)
            }
            
        }
        
        if c==d {
            while c==a||c==b||c==d {
                c = Int.random(in: 0...9)
            }
            
        }
        
    
    
    }
    
    func check(){
        let r1 = et.text
        
        if r1?.count != 4{ set_error()
            
        }else{
            let rep = Int(r1!)
            var a1 = 0; var b1 = 0; var c1 = 0;var d1 = 0; var juste = 0;var m_p = 0;
            
            a1 = rep!/1000
            b1 = (rep! % 1000)/100
            c1 = (rep!/10) - 100*a1 - 10*b1
            d1 = rep! - 10*(100*a1+10*b1+c1)
            
            if a1==b1||a1==c1||a1==d1||c1==b1||d1==b1||c1==d1{set_error()}
            else if a1==a&&b1==b&&c1==c&&d1==d{ //JUSTE
                
                line+=1
                let lineS = String(line)
                let a1S = String(a1)
                let b1S = String(b1)
                let c1S = String(c1)
                let d1S = String(d1)
                
                let answer = " " + lineS + "--" + a1S + b1S + c1S + d1S + "       "+"Correct"+"\n"
                           
                           
                //COLOR STRING
                let mutable = NSMutableAttributedString(string: answer, attributes:[NSAttributedString.Key.font : UIFont(name: "Kohinoor Bangla", size: CGFloat(setx(50)) )!] )
                               
                mutable.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location:15,length:7))
                mutable.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "line")!, range: NSRange(location:1,length:lineS.count+2))
                               
                mutableShown.append(mutable)
                tv.attributedText = mutableShown
                
            }else{
                if a1==a{juste+=1}else if a1==b||a1==c||a1==d{m_p+=1}
                
                if b1==b{juste+=1}else if b1==a||b1==c||b1==d{m_p+=1}
                
                if c1==c{juste+=1}else if c1==b||c1==a||c1==d{m_p+=1}
                
                if d1==d{juste+=1}else if d1==b||d1==c||d1==a{m_p+=1}
                
                if juste != 0 && m_p != 0 {
            
                    let j = String(juste)
                    let m = String(m_p)
                    s = j+"J"+m+"M"
                    
                }else if juste == 0 && m_p == 0{ s="----"}
                else if juste == 0 {
                    let m = String(m_p)
                    s = m+"M"
                }else {
                    let j = String(juste)
                    s = j+"J"
                }
                
                line+=1
                let lineS = String(line)
                let a1S = String(a1)
                let b1S = String(b1)
                let c1S = String(c1)
                let d1S = String(d1)
                
                let answer = " " + lineS + "--" + a1S + b1S + c1S + d1S + "       "+s+"\n"
                
                
                //COLOR STRING
                
                let mutable = NSMutableAttributedString(string: answer, attributes:[NSAttributedString.Key.font : UIFont(name: "Kohinoor Bangla", size: CGFloat(setx(50)) )!] )
                    
                mutable.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:15,length:s.count))
                mutable.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "line")!, range: NSRange(location:1,length:lineS.count+2))
                    
                mutableShown.append(mutable)
                tv.attributedText = mutableShown
                
                    
                    
            }
            
            //SCROLL TO DOWN
            if self.tv.bounds.size.height<self.tv.contentSize.height{
            let bottomOffset = CGPoint(x: 0, y: self.tv.contentSize.height - self.tv.bounds.size.height)
            tv.setContentOffset(bottomOffset, animated: true)
            }
            et.text = ""
            
        }

        
    
    }
    
    func set_error(){
        
        error = true
        
        //MAKE SCREEN DIM
         dim = UIView(frame:CGRect(x:0,y:0,width:start.width,height:start.height))
         dim.backgroundColor = .black
         self.view.addSubview(dim)
         dim.alpha = 0.66
        
        let a = setx((1080-700)/2)
        let b = sety((1770-300)/2)
        
        let msg_box = UIView(frame:CGRect(x:a,y:b,width:setx(700),height:sety(300)))
        let img = UIImage(named: "error_box")
        msg_box.layer.contents = img?.cgImage
        self.view.addSubview(msg_box)
        Msg_box = msg_box
        
        let okay = UIButton(frame:CGRect(x:setx((700-200)/2),y:sety(300-100-20),width:setx(200),height:sety(100)))
        
        okay.setImage(UIImage(named: "okay_button"), for:.normal)
        okay.addTarget(self,action :#selector(okay_btn), for:.touchUpInside)
        msg_box.addSubview(okay)
        
        
      
        
    }
    
    @objc func okay_btn(_sender: UIButton){
          
         
              Msg_box.isHidden = true
              dim.isHidden = true
        
              error = false
              
              
          }

    func make_textView(){
        
        //MAKE EDIT TEXT
        let a=(1080-200*3-30*3)/2
        let b=200*3+30*2
        
        tv = UITextView(frame:CGRect(x:setx(a),y:sety(50),width:setx(b),height:sety(550)))
        tv.textColor = .black
        tv.textAlignment = .natural
        self.view.addSubview(tv)
        let color = UIColor(named: "border")
        tv.layer.backgroundColor = UIColor.clear.cgColor
        tv.layer.borderColor = color?.cgColor
        tv.layer.borderWidth = 3.0
        tv.isEditable = false
        
       
        
    }
                                     
    func make_editText(){
        
        //MAKE EDIT TEXT
        let a=(1080-200*3-30*3)/2
        let b=200*3+30*2
        
        et = UILabel(frame:CGRect(x:setx(a),y:sety(650),width:setx(b),height:sety(100)))
        et.textColor = .black
        et.textAlignment = .center
        et.adjustsFontSizeToFitWidth = true
        self.view.addSubview(et)
        et.font = et.font.withSize(CGFloat(setx(50)))
        let color = UIColor(named: "border")
        et.layer.borderColor = color?.cgColor
        et.layer.borderWidth = 3.0
        
    }
    
    func make_confirm_buttons(){
        
        //MAKE CONFIRM BUTTONS
               let a=1080-400-100
               
               
        confirm = UIButton(frame:CGRect(x:setx(a),y:sety(1400),width:setx(400),height:sety(150)))
        confirm.setImage(UIImage(named: "check_button"), for:.normal)
        confirm.addTarget(self,action :#selector(confirm_button), for:.touchUpInside)
        self.view.addSubview(confirm)
        
        
        replay = UIButton(frame:CGRect(x:setx(100),y:sety(1400),width:setx(400),height:sety(150)))
        replay.setImage(UIImage(named: "again_button"), for:.normal)
        replay.addTarget(self,action :#selector(replay_button), for:.touchUpInside)
        self.view.addSubview(replay)
             
            
        
        
    }
    
    @objc func confirm_button(sender: UIButton){
    
    if !error{
        check()
        }
        
        
    }
    
    @objc func replay_button(sender: UIButton){
    
        if !error{
            mutableShown = NSMutableAttributedString(string: "")
        tv.attributedText = mutableShown
        et.text = ""
        generate_randoms()
        line = 0
        }
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
    
    func make_keyboard(){
        
        let a=(1080-200*3-30*3)/2
        let b=a+200+30
        let c=2*b-a
        let d=(1080-200*2-30*2)/2
        
        //MAKING THE BUTTONS
        let btn1 = UIButton(frame:CGRect(x:setx(a),y:sety(800),width:setx(200),height:sety(120)))
        btn1.setImage(UIImage(named: "1_button"), for:.normal)
        btn1.addTarget(self,action :#selector(btn_1), for:.touchUpInside)
        self.view.addSubview(btn1)
        
        
        let btn2 = UIButton(frame:CGRect(x:setx(b),y:sety(800),width:setx(200),height:sety(120)))
        btn2.setImage(UIImage(named: "2_button"), for:.normal)
        btn2.addTarget(self,action :#selector(btn_2), for:.touchUpInside)
        self.view.addSubview(btn2)
        
        
        let btn3 = UIButton(frame:CGRect(x:setx(c),y:sety(800),width:setx(200),height:sety(120)))
        btn3.setImage(UIImage(named: "3_button"), for:.normal)
        btn3.addTarget(self,action :#selector(btn_3), for:.touchUpInside)
        self.view.addSubview(btn3)
        
        
        let btn4 = UIButton(frame:CGRect(x:setx(a),y:sety(950),width:setx(200),height:sety(120)))
        btn4.setImage(UIImage(named: "4_button"), for:.normal)
        btn4.addTarget(self,action :#selector(btn_4), for:.touchUpInside)
        self.view.addSubview(btn4)
        
        
        let btn5 = UIButton(frame:CGRect(x:setx(b),y:sety(950),width:setx(200),height:sety(120)))
        btn5.setImage(UIImage(named: "5_button"), for:.normal)
        btn5.addTarget(self,action :#selector(btn_5), for:.touchUpInside)
        self.view.addSubview(btn5)
        
        
        let btn6 = UIButton(frame:CGRect(x:setx(c),y:sety(950),width:setx(200),height:sety(120)))
        btn6.setImage(UIImage(named: "6_button"), for:.normal)
        btn6.addTarget(self,action :#selector(btn_6), for:.touchUpInside)
        self.view.addSubview(btn6)
        
        let btn7 = UIButton(frame:CGRect(x:setx(a),y:sety(1100),width:setx(200),height:sety(120)))
        btn7.setImage(UIImage(named: "7_button"), for:.normal)
        btn7.addTarget(self,action :#selector(btn_7), for:.touchUpInside)
        self.view.addSubview(btn7)
        
        
        let btn8 = UIButton(frame:CGRect(x:setx(b),y:sety(1100),width:setx(200),height:sety(120)))
        btn8.setImage(UIImage(named: "8_button"), for:.normal)
        btn8.addTarget(self,action :#selector(btn_8), for:.touchUpInside)
        self.view.addSubview(btn8)
        
        
        let btn9 = UIButton(frame:CGRect(x:setx(c),y:sety(1100),width:setx(200),height:sety(120)))
        btn9.setImage(UIImage(named: "9_button"), for:.normal)
        btn9.addTarget(self,action :#selector(btn_9), for:.touchUpInside)
        self.view.addSubview(btn9)
        
        
        let btn0 = UIButton(frame:CGRect(x:setx(d),y:sety(1250),width:setx(200),height:sety(120)))
        btn0.setImage(UIImage(named: "0_button"), for:.normal)
        btn0.addTarget(self,action :#selector(btn_0), for:.touchUpInside)
        self.view.addSubview(btn0)
        
        
        let del = UIButton(frame:CGRect(x:setx(d+200+30),y:sety(1250),width:setx(200),height:sety(120)))
        del.setImage(UIImage(named: "del_button"), for:.normal)
        del.addTarget(self,action :#selector(btn_del), for:.touchUpInside)
        self.view.addSubview(del)
        
        
        
    }
    @objc func btn_1(sender: UIButton){
        
        et.text = (et.text ?? "")+"1"
           
        }
    @objc func btn_2(sender: UIButton){
               
                  et.text = (et.text ?? "")+"2"
           
        }
    @objc func btn_3(sender: UIButton){
               
                  et.text = (et.text ?? "")+"3"
           
        }
    @objc func btn_4(sender: UIButton){
               
                  et.text = (et.text ?? "")+"4"
           
        }
    @objc func btn_5(sender: UIButton){
               
                  et.text = (et.text ?? "")+"5"
           
        }
    @objc func btn_6(sender: UIButton){
               
                  et.text = (et.text ?? "")+"6"
           
        }
    @objc func btn_7(sender: UIButton){
               
                  et.text = (et.text ?? "")+"7"
           
        }
    @objc func btn_8(sender: UIButton){
               
                  et.text = (et.text ?? "")+"8"
           
        }
    @objc func btn_9(sender: UIButton){
               
                  et.text = (et.text ?? "")+"9"
           
        }
    @objc func btn_0(sender: UIButton){
               
                  et.text = (et.text ?? "")+"0"
           
        }
    @objc func btn_del(sender: UIButton){
               
        let et1 = UITextField(frame:CGRect(x:0,y:0,width:0,height:0))
        et1.insertText(et.text!)
        et1.deleteBackward()
        et.text=et1.text
        
           
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

    

}
