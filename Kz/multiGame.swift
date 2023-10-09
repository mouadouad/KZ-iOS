//
//  multiGame.swift
//  Kz
//
//  Created by mouad ouad on 28/03/2020.
//  Copyright © 2020 mouad ouad. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import SystemConfiguration

class multiGame: UIViewController {
    
    var et = UILabel(frame:CGRect(x:0,y:0,width:0,height:0))
    var tv = UITextView(frame:CGRect(x:0,y:0,width:0,height:0))
    var timerV = UITextView(frame:CGRect(x:0,y:0,width:0,height:0))
    var confirm = UIButton(frame:CGRect(x:0,y:0,width:0,height:0))
    var replayB = UIButton(frame:CGRect(x:0,y:0,width:0,height:0))
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
    var play_again = UIView(frame:CGRect(x:0,y:0,width:0,height:0))
    
    var ref: DatabaseReference!
    var my_player: DatabaseReference!
    var his_player: DatabaseReference!
    
    var I_repeat = false
    var He_repeat = false
    var win = false
    var played = true
    
    var timer:Timer?
    let time = 120
    var timeLeft = 0
    var player: AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       //SET BACKGROUND COLOR
       view.backgroundColor = UIColor(named: "background_color")
       
        
        
       make_keyboard()
       make_editText()
       make_textView()
       make_confirm_buttons()
       setTimer()
        
        //SEE WHICH PLAYER
        ref = Database.database().reference()
        
        if multi.sender == "create"{
           
            my_player = ref.child(multi.name).child("player1")
            his_player = ref.child(multi.name).child("player2")
        }else{
            my_player = ref.child(multi.name).child("player2")
            his_player = ref.child(multi.name).child("player1")
            
        }
        
        start_randoms()
        
        //SEE IF WANT RO REPEAT
        his_player.child("repeat").observe(.value) { (snapshot) in
            
            let string1 = snapshot.value as? String
            
            if string1 == "1"{
                //HE WANTS TO REPLAY
                self.He_repeat = true
                
                if self.I_repeat{
                    self.replay()  //I ALREADY WANT TO REPLAY
                }else{
                    self.play_again = UIView(frame:CGRect(x:self.setx(190),y:self.sety(505),width:self.setx(700),height:self.sety(180)))
                    let img = UIImage(named: "play_again_box")
                    self.play_again.layer.contents = img?.cgImage
                    self.view.addSubview(self.play_again)
                    
                }
                
            }
            
        }
        
        startT()
        back()
    }
    
    func setTimer(){
        
        timerV = UITextView(frame:CGRect(x:setx(310),y:sety(1420),width:setx(200),height:sety(120)))
        timerV.textColor = .black
        timerV.textAlignment = .natural
        timerV.font = UIFont(name: "Kohinoor Bangla", size: CGFloat(setx(60)))
        timerV.layer.backgroundColor = UIColor.clear.cgColor
        self.view.addSubview(timerV)
        timerV.isEditable = false
        
    }
    
    func startT(){
        
        timeLeft = time
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update),userInfo: nil, repeats: true)
        
    }
    
    @objc func update(){
        
        timeLeft -= 1
        let minutes = timeLeft/60
        let seconds = timeLeft%60
        let min = String(minutes)
        var sec = String(seconds)
        if seconds<10 {sec = "0"+sec }
        timerV.text = min+":"+sec
        
        if timeLeft == 0 {
            //IF TIME FINISHED
            my_player.child("ready").setValue("1")
            line += 1
            
            his_player.child("ready").observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? String
                
                if value == "2"{
                    self.lost() //SEE IF LOST
                }else{
                    self.reset()
                    self.his_player.child("ready").setValue("0")  //RESET
                }
                
                
            }
        }
        
    }
    
    func pause(){
        timer?.invalidate()
        
    }
    
    func reset(){
        pause()
        timer = nil
        startT()
        playSound()
        
    }
    
    func start_randoms(){
        
        //SEE WHO ENTRED FIRST AND GIVE RANDOMS
        my_player.child("side").observeSingleEvent(of: .value) { (snapshot) in
        
            let entredFirst = snapshot.value as? String
            
            if entredFirst == "0"{
                
                
                self.generate_randoms()
                
                //SEND RANDOMS
                self.his_player.child("rana").setValue(self.a)
                self.his_player.child("ranb").setValue(self.b)
                self.his_player.child("ranc").setValue(self.c)
                self.his_player.child("rand").setValue(self.d)
                
                //I ENTRED FIRST
                self.his_player.child("side").setValue("1")
                
            }else{
                //RETRIVE RANDOMS
                
                self.my_player.child("rana").observeSingleEvent(of: .value) { (snapshot) in
                    self.a = (snapshot.value as? Int)!
                }
                self.my_player.child("ranb").observeSingleEvent(of: .value) { (snapshot) in
                    self.b = (snapshot.value as? Int)!
                }
                self.my_player.child("ranc").observeSingleEvent(of: .value) { (snapshot) in
                   self.c = (snapshot.value as? Int)!
               }
                self.my_player.child("rand").observeSingleEvent(of: .value) { (snapshot) in
                    self.d = (snapshot.value as? Int)!
                }
                
            }
            
            
        }
        
        
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
              
              win = true
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
  
    @objc func okay_btn(sender: UIButton){
        
       
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
      

      
  }
  
    @objc func confirm_button(sender: UIButton){
  
        //CHECK INTERNET
        if !Reachability.isConnectedToNetwork(){internet_error()}
        else {
            
        if !error{ //IF THERE IS NO ERROR
                
            if played { //IF I PLAYED
                check()
                if win {my_player.child("ready").setValue("2")}else{my_player.child("ready").setValue("1")} //IF I HAD IT RIGHT OR NOT
            
                played = false
                pause()
                
                his_player.child("ready").observe(.value) { (snapshot) in
                    
                    if !self.played{ //IF I PLAYED
                        
                        let ready = snapshot.value as! String
                        
                        if ready == "1"{ //IF HE PLAYED AND HAD IT WRONG
                            self.played = true
                            self.his_player.child("ready").setValue("0")
                            self.reset()
                            if self.win {self.won()}
                        }else if ready == "2"{ //IF HE PLAYED AND HAD IT RIGHT
                            self.reset()
        
                            if self.win {self.draw()}else{self.lost()}
                            
                        }
                    }
                }
                
            }
            
            
        }
            
            
    }
      
      
  }
  
    func won(){
        
        //MAKE SCREEN DIM
         dim = UIView(frame:CGRect(x:0,y:0,width:start.width,height:start.height))
         dim.backgroundColor = .black
         self.view.addSubview(dim)
         dim.alpha = 0.66
        
        let a = setx((1080-700)/2)
        let b = sety((1770-300)/2)
        
        let msg_box = UIView(frame:CGRect(x:a,y:b,width:setx(700),height:sety(300)))
        let img = UIImage(named: "win_box")
        msg_box.layer.contents = img?.cgImage
        self.view.addSubview(msg_box)
        Msg_box = msg_box
        
        replay_button()
        
    }
    
    func lost(){
        
        //MAKE SCREEN DIM
         dim = UIView(frame:CGRect(x:0,y:0,width:start.width,height:start.height))
         dim.backgroundColor = .black
         self.view.addSubview(dim)
         dim.alpha = 0.66
        
        let a = setx((1080-700)/2)
        let b = sety((1770-300)/2)
        
        let msg_box = UIView(frame:CGRect(x:a,y:b,width:setx(700),height:sety(300)))
        let img = UIImage(named: "lost_box")
        msg_box.layer.contents = img?.cgImage
        self.view.addSubview(msg_box)
        Msg_box = msg_box
        
        replay_button()
    }
    
    func draw(){
        
        //MAKE SCREEN DIM
         dim = UIView(frame:CGRect(x:0,y:0,width:start.width,height:start.height))
         dim.backgroundColor = .black
         self.view.addSubview(dim)
         dim.alpha = 0.66
        
        let a = setx((1080-700)/2)
        let b = sety((1770-300)/2)
        
        let msg_box = UIView(frame:CGRect(x:a,y:b,width:setx(700),height:sety(300)))
        let img = UIImage(named: "draw_box")
        msg_box.layer.contents = img?.cgImage
        self.view.addSubview(msg_box)
        Msg_box = msg_box
        
        replay_button()
    }
    
    func replay(){
        
        killVC()
        let vc = waiting()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    
    func killVC(){
        timer?.invalidate()
        dismiss(animated: false, completion: nil)
        
    }
    
    func replay_button(){
        
        replayB = UIButton(frame:CGRect(x:setx((700-250)/2),y:sety(300-100-20),width:setx(250),height:sety(100)))
        replayB.setImage(UIImage(named: "again_button"), for:.normal)
        replayB.addTarget(self,action :#selector(replayB_btn), for:.touchUpInside)
        Msg_box.addSubview(replayB)
             
    }
    
    @objc func replayB_btn(sender: UIButton){
        
        I_repeat = true
        my_player.child("repeat").setValue("1")
        
        if I_repeat&&He_repeat{
            //SEE IF HE ALREADY WANT TO REPLAY
            replay()
            
        }
        
    }
    
    func back(){
           
           let back = UIButton(frame:CGRect(x:setx(50),y:sety(50),width:setx(100),height:sety(100)))
           back.setImage(UIImage(named: "back_button"), for:.normal)
           back.addTarget(self,action :#selector(back_button), for:.touchUpInside)
           self.view.addSubview(back)
           
       }
       
    @objc func back_button(sender: UIButton){

          timer?.invalidate()
          self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
           
   
       }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "time_start_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)



            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public class Reachability {

        class func isConnectedToNetwork() -> Bool {

            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)

            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }

            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }

            // Working for Cellular and WIFI
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            let ret = (isReachable && !needsConnection)

            return ret

        }
    }
    
    func internet_error(){
        
        
        
           //MAKE SCREEN DIM
             dim = UIView(frame:CGRect(x:0,y:0,width:start.width,height:start.height))
             dim.backgroundColor = .black
             self.view.addSubview(dim)
             dim.alpha = 0.66
            
            let a = setx((1080-700)/2)
            let b = sety((1770-300)/2)
            
            let msg_box = UIView(frame:CGRect(x:a,y:b,width:setx(700),height:sety(300)))
            let img = UIImage(named: "internet_box")
            msg_box.layer.contents = img?.cgImage
            self.view.addSubview(msg_box)
            Msg_box = msg_box
            
            let okay = UIButton(frame:CGRect(x:setx((700-200)/2),y:sety(300-100-20),width:setx(200),height:sety(100)))
            
            okay.setImage(UIImage(named: "okay_button"), for:.normal)
            okay.addTarget(self,action :#selector(okay_btn), for:.touchUpInside)
            msg_box.addSubview(okay)
            
            
          
            
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
