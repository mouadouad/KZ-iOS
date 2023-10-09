//
//  start.swift
//  Kz
//
//  Created by mouad ouad on 21/03/2020.
//  Copyright © 2020 mouad ouad. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds




class start: UIViewController,GADInterstitialDelegate {
    
    public static var height: CGFloat = 0
    public static var width: CGFloat = 0
    var Normal_button: UIButton = UIButton(frame:CGRect(x:0,y:0,width:0,height:0))
    var Multi: UIButton = UIButton(frame:CGRect(x:0,y:0,width:0,height:0))
    var Tuto: UIButton = UIButton(frame:CGRect(x:0,y:0,width:0,height:0))
    var icon = UIImageView(frame:CGRect(x:0,y:0,width:0,height:0))
    var interstitial: GADInterstitial!
    var moved = false
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        FirebaseApp.configure()
        
        //SET BACKGROUND COLOR
        view.backgroundColor = UIColor(named: "background_color")
        
        //GET SCREEN SIZE
        let screenSize = UIScreen.main.bounds
        start.width = screenSize.width
        start.height = screenSize.height
        
        //MAKING THE BUTTONS
        Normal_button = UIButton(frame:CGRect(x:setx((1080-300)/2),y:Int(start.height),width:setx(300),height:sety(150)))
        let image = UIImage(named: "normal_button") as UIImage?
        Normal_button.setImage(image, for:.normal)
        Normal_button.addTarget(self,action :#selector(goto_normal), for:.touchUpInside)
        self.view.addSubview(Normal_button)
        
        Multi = UIButton(frame:CGRect(x:setx((1080-300)/2),y:Int(start.height),width:setx(300),height:sety(150)))
        let image1 = UIImage(named: "multi_button") as UIImage?
        Multi.setImage(image1, for:.normal)
        Multi.addTarget(self,action :#selector(goto_multi), for:.touchUpInside)
        self.view.addSubview(Multi)
        
        Tuto = UIButton(frame:CGRect(x:setx(1080-300),y:0,width:setx(250),height:sety(150)))
        let image2 = UIImage(named: "tuto_button") as UIImage?
        Tuto.setImage(image2, for:.normal)
        Tuto.addTarget(self,action :#selector(goto_tuto), for:.touchUpInside)
        self.view.addSubview(Tuto)
        
        //MAKE THE KZ LOGO
        icon = UIImageView(frame:CGRect(x:setx((1080-400)/2),y:0,width:setx(400),height:sety(300)))
        let image3 = UIImage(named: "KZ logo") as UIImage?
        icon.image = image3
        self.view.addSubview(icon)
        
     
        //ANIMATE
        UIView.animate(withDuration: 1){
            self.Normal_button.transform = CGAffineTransform(translationX: 0, y: -CGFloat(self.sety(1000)))
            self.Multi.transform = CGAffineTransform(translationX: 0, y: -CGFloat(self.sety(800)))
            self.Tuto.transform = CGAffineTransform(translationX: 0, y: CGFloat(self.sety(100)))
            self.icon.transform = CGAffineTransform(translationX: 0, y: CGFloat(self.sety(300)))
            
        }
        
        //ADD INTERSTITIEL
        interstitial = createAndLoadInterstitial()
         
      
    }
    
    @objc func goto_normal(sender: UIButton){
        
     //   for view in self.view.subviews {
      //      view.removeFromSuperview()
   //     }
        
       //let twoController = Normal.init(nibName: "Normal", bundle: nil)
        //twoController.viewDidLoad()
      //  let vc = Normal()
    
       // vc.delegate = self
     //   self.present(vc, animated: false)
        
       // let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainGme") as! Normal
         //       self.present(newViewController, animated: true)
        
        let vc = Normal()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
        
        
       // self.performSegue(withIdentifier: "segue", sender: self)
    }
    @objc func goto_multi(sender: UIButton){
        
        if interstitial.isReady {
           interstitial.present(fromRootViewController: self)
         }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) { // Change `2.0` to the desired number of seconds.
            if !self.moved {
                let vc = multi()
                vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func createAndLoadInterstitial() -> GADInterstitial {
      let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
        
        let vc = multi()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
        moved = true
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      moved = true
    }
    
    
    @objc func goto_tuto(sender: UIButton){
           
        let vc = tuto()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
           
       }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait

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



}

