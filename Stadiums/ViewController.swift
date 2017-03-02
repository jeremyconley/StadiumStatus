//
//  ViewController.swift
//  Stadiums
//
//  Created by Jeremy Conley on 11/18/16.
//  Copyright © 2016 JeremyConley. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var logInButton: UIBarButtonItem!
    
    @IBOutlet weak var mlbButton: UIButton!
    @IBOutlet weak var nflButton: UIButton!
    
    //Logged in or out
    var loggedIn = false
    var alert = UIAlertController()
    
    //Setup nav image
    let stadiumImg = UIImage(named: "StadiumBarImg")
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            //LoggedIn
            loggedIn = true
            logInButton.image = #imageLiteral(resourceName: "logOut")

        } else {
            loggedIn = false
            logInButton.image = #imageLiteral(resourceName: "logIn")
            //notLoggedIn
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup nav image
        let stadiumImgView = UIImageView(image: stadiumImg)
        stadiumImgView.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        stadiumImgView.contentMode = .scaleAspectFit
        containerView.addSubview(stadiumImgView)
        
        self.navigationItem.titleView = containerView

        
        let date = NSDate()
        let calender = NSCalendar.current
        let hour = calender.component(.hour, from: date as Date)
        let minutes = calender.component(.minute, from: date as Date)
        print("\(hour)" + " " + "\(minutes)")
        
        setupButtonViews()
        
        print(self.view.frame.height)
        
    }
    
    func setupButtonViews(){
        let height = self.navigationController?.navigationBar.frame.height
        nflButton.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: mlbButton.topAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: (self.view.frame.height / 2) - height!)
        mlbButton.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        let nflButtonOrigin = nflButton.frame.origin
        let mlbButtonOrigin = mlbButton.frame.origin
        
        animateButtons(nflOrigin: nflButtonOrigin, mlbOrigin: mlbButtonOrigin)
        
    }
    
    func animateButtons(nflOrigin: CGPoint, mlbOrigin: CGPoint){
        nflButton.frame = CGRect(x: nflButton.frame.width, y: nflOrigin.y, width: nflButton.frame.width, height: nflButton.frame.height)
        mlbButton.frame = CGRect(x: -mlbButton.frame.width, y: mlbOrigin.y, width: mlbButton.frame.width, height: mlbButton.frame.height)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: { 
            self.nflButton.frame = CGRect(x: nflOrigin.x, y: nflOrigin.y, width: self.nflButton.frame.width, height: self.nflButton.frame.height)
             self.mlbButton.frame = CGRect(x: mlbOrigin.x, y: mlbOrigin.y, width: self.mlbButton.frame.width, height: self.mlbButton.frame.height)
            }) { (completed) in
                //
        }
        
        
    }
    
    func loggedOutAlert(){
        alert = UIAlertController(title: "Logged out", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func logInAction(_ sender: AnyObject) {
        if loggedIn == true {
            try! FIRAuth.auth()?.signOut()
            logInButton.image = #imageLiteral(resourceName: "logIn")
            loggedIn = false
            loggedOutAlert()
        } else {
            self.performSegue(withIdentifier: "logInFromHome", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

