//
//  LoginViewController.swift
//  Stadiums
//
//  Created by Jeremy Conley on 1/23/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var nflImgView: UIImageView!
    @IBOutlet weak var mlbImg: UIImageView!
    
    //Alert
    var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Button Layout
        logInButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        
        setupViews()
        
        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
        
        //Anchor images to bottom
        mlbImg.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: self.view.frame.width, heightConstant: self.view.frame.height / 3)
        nflImgView.anchor(nil, left: self.view.leftAnchor, bottom: mlbImg.topAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 1, rightConstant: 0, widthConstant: self.view.frame.width, heightConstant: self.view.frame.height / 3)
        
        
        emailTextField.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 55, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: self.view.frame.width - 20, heightConstant: 30)
        passwordTextField.anchor(emailTextField.bottomAnchor, left: emailTextField.leftAnchor, bottom: nil, right: emailTextField.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: emailTextField.frame.width, heightConstant: 30)
        usernameTextField.anchor(passwordTextField.bottomAnchor, left: passwordTextField.leftAnchor, bottom: nil, right: passwordTextField.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: passwordTextField.frame.width, heightConstant: 30)
        
        //Double the size of button (Because there are 2) minus the space inbetween divided by 2 for both sides
        let buttonContants = (self.view.frame.width - ((75 * 2) + 30)) / 2
        
        logInButton.anchor(usernameTextField.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: buttonContants, bottomConstant: 10, rightConstant: 0, widthConstant: 75, heightConstant: 30)
        signUpButton.anchor(logInButton.topAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: buttonContants, widthConstant: 75, heightConstant: 30)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func loginTapped(_ sender: AnyObject) {
        // Sign In with credentials.
        let email = emailTextField.text
        let password = passwordTextField.text
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.invalidLogin()
                return
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signupTapped(_ sender: AnyObject) {
        //Open username textfield
        usernameTextField.isHidden = false
        
        if usernameTextField.text == ""{
            
        } else {
            let email = emailTextField.text
            let password = passwordTextField.text
            FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    if error.localizedDescription == "The email address is already in use by another account."{
                        self.invalidSignup(error: "The email address is already in use by another account.")
                    } else {
                        self.invalidSignup(error: "The password must be 6 characters long or more.")
                    }
                    return
                } else {
                    let userId = (user?.uid)! as String
                    let newUser = User(username: self.usernameTextField.text!, userId: userId, email: email!)
                    let ref = FIRDatabase.database().reference(withPath: "users")
                    ref.childByAutoId().setValue(newUser.toAnyObject())
                    self.setDisplayName(user)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    func setDisplayName(_ user: FIRUser?) {
        let changeRequest = user?.profileChangeRequest()
        changeRequest?.displayName = usernameTextField.text
        changeRequest?.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Alert Functions
    func invalidSignup(error: String){
        alert = UIAlertController(title: "Invalid Signup", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func invalidLogin(){
        alert = UIAlertController(title: "Invalid Login", message: "Invalid email or password", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
