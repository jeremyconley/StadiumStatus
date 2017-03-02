//
//  LaunchAnimationVC.swift
//  Stadiums
//
//  Created by Jeremy Conley on 2/17/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit

class LaunchAnimationVC: UIViewController {
    
    let stadiumLogoView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "StadiumBarImg")
        return imgView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stadiumLogoView)
        stadiumLogoView.frame.size = CGSize(width: 100, height: 100)
        stadiumLogoView.center = self.view.center
        
        let smallPath = UIBezierPath(rect: CGRect(origin: stadiumLogoView.frame.origin, size: CGSize(width: 50, height: 50)))
        
        animateLogo()
        
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseIn, animations: {
            self.stadiumLogoView.frame.size = CGSize(width: 50, height: 50)
            self.stadiumLogoView.center = self.view.center
            }) { (completed) in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.stadiumLogoView.frame.size = CGSize(width: 100, height: 100)
                    self.stadiumLogoView.center = self.view.center
                }) { (completed) in
                    //
                }
        }

        
        
    }
    
    func animateLogo(){
        let delay = 1.0
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0 * CGFloat(M_PI/180)
        rotationAnimation.toValue = 360 * CGFloat(M_PI/180)
        rotationAnimation.beginTime = CACurrentMediaTime() + delay
        let innerAnimationDuration : CGFloat = 0.3
        rotationAnimation.duration = Double(innerAnimationDuration)
        self.stadiumLogoView.layer.add(rotationAnimation, forKey: "rotateInner")
        
        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                self.performSegue(withIdentifier: "launchComplete", sender: self)
            }
        } else {
            // Fallback on earlier versions
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "launchComplete", sender: self)
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
