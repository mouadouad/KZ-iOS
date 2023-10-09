//
//  join.swift
//  Kz
//
//  Created by mouad ouad on 27/03/2020.
//  Copyright © 2020 mouad ouad. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import GoogleMobileAds

class join: UIViewController {
    
    var nameOfLobby = UITextField(frame:CGRect(x:0,y:0,width:0,height:0))
    var join = UIButton(frame:CGRect(x:0,y:0,width:0,height:0))
    var tv = UITextView(frame:CGRect(x:0,y:0,width:0,height:0))
    var ref: DatabaseReference!
    var dim = UIView(frame:CGRect(x:0,y:0,width:0,height:0))
    var Msg_box = UIView(frame:CGRect(x:0,y:0,width:0,height:0))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        ref = Database.database().reference()
        
      //SET BACKGROUND COLOR
      view.backgroundColor = UIColor(named: "background_color")
        

    nameOfLobby = UITextField(frame:CGRect(x:setx(400),y:sety(200),width:setx(300),height:sety(150)))
        let bottomline = CALayer()
        bottomline.frame = CGRect(x: 0.0 , y: nameOfLobby.frame.height - 1, width: nameOfLobby.frame.width, height: 1)
        bottomline.backgroundColor = UIColor.black.cgColor
        nameOfLobby.borderStyle = UITextField.BorderStyle.none
        nameOfLobby.layer.addSublayer(bottomline)
      self.view.addSubview(nameOfLobby)
        
        tv = UITextView(frame:CGRect(x:setx(400),y:sety(350),width:setx(600),height:sety(100)))
        tv.textColor = .red
        tv.textAlignment = .natural
        tv.layer.backgroundColor = UIColor.clear.cgColor
        tv.font = UIFont(name: "Georgia", size: CGFloat(setx(40)))
        tv.isEditable = false
        self.view.addSubview(tv)
                
     makeButtons()
        
        back()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
                     
          }
    
    
    func makeButtons(){
        
        join = UIButton(frame:CGRect(x:setx(400),y:sety(500),width:setx(300),height:sety(150)))
             join.setImage(UIImage(named: "join_button"), for:.normal)
             join.addTarget(self,action :#selector(join_button), for:.touchUpInside)
             self.view.addSubview(join)
        
    }
    
          
    @objc func join_button(sender: UIButton){
        
        
    if !Reachability.isConnectedToNetwork(){internet_error()}
            
    else if nameOfLobby.text!.isEmpty{
        
      set_error("Lobby doesn't exist")
        
    }else{
        
        multi.name = nameOfLobby.text!
        let lobby = ref.child(multi.name)
        lobby.child("player1").child("ready").observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists(){
                
                
                lobby.child("joined").observeSingleEvent(of: .value) { (snapshot) in
                    
                    if !snapshot.exists(){
                        
                        multi.sender = "join"
                       let vc = waiting()
                        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    
                    
                }
                
            }else {
                
                self.set_error("Lobby doesn't exist")
                
            }
            
            
        }
        
        
        
    }
    
    
            
        }
    
    func set_error(_ error: String){
        
        
        tv.text = error
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
        
    @objc func okay_btn(_sender: UIButton){
              
             
        Msg_box.isHidden = true
        dim.isHidden = true
                
                  
        }
    
    func back(){
           
           let back = UIButton(frame:CGRect(x:setx(50),y:sety(50),width:setx(100),height:sety(100)))
           back.setImage(UIImage(named: "back_button"), for:.normal)
           back.addTarget(self,action :#selector(back_button), for:.touchUpInside)
           self.view.addSubview(back)
           
       }
       
    @objc func back_button(sender: UIButton){
        
        let vc = multi()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
        
    }
    
    var bannerView: GADBannerView!
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: bottomLayoutGuide,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
         bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

}
