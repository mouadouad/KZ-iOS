//
//  waiting.swift
//  Kz
//
//  Created by mouad ouad on 27/03/2020.
//  Copyright © 2020 mouad ouad. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import GoogleMobileAds

class waiting: UIViewController {
    
    var ref: DatabaseReference!
    var lobby : DatabaseReference!
    var joined = false
    var play : UIButton = UIButton(frame:CGRect(x:0,y:0,width:0,height:0))
    var dim = UIView(frame:CGRect(x:0,y:0,width:0,height:0))
    var Msg_box = UIView(frame:CGRect(x:0,y:0,width:0,height:0))


    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        ref = Database.database().reference()
        lobby = ref.child(multi.name)
        
        //SET BACKGROUND COLOR
        view.backgroundColor = UIColor(named: "background_color")

        
        //MAKE THE BUTTON
        play = UIButton(frame:CGRect(x:setx(400),y:sety(500),width:setx(300),height:sety(150)))
        
        if multi.sender == "join"{
         play.setImage(UIImage(named: "play_on_button"), for:.normal)
        }else{
            play.setImage(UIImage(named: "play_off_button"), for:.normal)
        }
         play.addTarget(self,action :#selector(play_button), for:.touchUpInside)
         self.view.addSubview(play)
        
        //MAKE THE NAME OF LOBBY TV
        let tv = UITextView(frame:CGRect(x:setx(400),y:sety(800),width:setx(600),height: 0))
               tv.textColor = .black
               tv.textAlignment = .natural
               self.view.addSubview(tv)
               tv.layer.backgroundColor = UIColor.clear.cgColor
               tv.isEditable = false
             
        let mutable = NSMutableAttributedString(string:"Name of Lobby : "+multi.name, attributes:[NSAttributedString.Key.font : UIFont(name: "Kohinoor Bangla", size: CGFloat(setx(60)) )!] )
                                      
        mutable.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "line")!, range: NSRange(location:16,length:multi.name.count))
        tv.attributedText = mutable
        tv.sizeToFit()
        
        
        //SEE IF CREATED OR JOINED
        if multi.sender == "create"{
            
            self.lobby.child("player1").child("ready").setValue("0")
            self.lobby.child("player1").child("side").setValue("0")
            self.lobby.child("player1").child("repeat").setValue("0")
            self.lobby.child("player2").child("ready").setValue("0")
            self.lobby.child("player2").child("side").setValue("0")
            self.lobby.child("player2").child("repeat").setValue("0")
            
            lobby.child("joined").observe(.value) { (snapshot) in
                if snapshot.exists(){
                    
                    self.joined = true
                    self.play.setImage(UIImage(named: "play_on_button"), for:.normal)
                    
                }
            }
            
              }else{
            
            self.joined = true
            lobby.child("joined").setValue("1")
            
              }
                        
             back()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
    
    
    }
    
    @objc func play_button(sender: UIButton){
              
        
        if !Reachability.isConnectedToNetwork(){internet_error()}
        else if joined{
            
            let vc = multiGame()
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
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
