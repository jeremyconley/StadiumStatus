//
//  RatingViewController.swift
//  Stadiums
//
//  Created by Jeremy Conley on 1/23/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit
import Firebase

class RatingViewController: UIViewController, UITextViewDelegate {
    
    let ratingsRef = FIRDatabase.database().reference(withPath: "ratings")
    var currentUserExistingRating = false;
    
    
    //Alert
    var alert = UIAlertController()

    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var currentStadium = String()
    var starRating = 0
    let filledStar = UIImage(named: "star_filled.png")
    let unfilledStar = UIImage(named: "star_unfilled.png")
    
    
    var invalidComment = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadStadiumRatings()
        submitButton.layer.cornerRadius = 10
        commentTextView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        let starSize = (self.view.frame.width - 40) / 5
        
        star1.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 85, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: starSize, heightConstant: starSize)
        star2.anchor(star1.topAnchor, left: star1.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: starSize, heightConstant: starSize)
        star3.anchor(star2.topAnchor, left: star2.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: starSize, heightConstant: starSize)
        star4.anchor(star3.topAnchor, left: star3.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: starSize, heightConstant: starSize)
        star5.anchor(star4.topAnchor, left: star4.rightAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 10, widthConstant: starSize, heightConstant: starSize)
        
        commentLabel.anchor(star1.bottomAnchor, left: star1.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        characterCountLabel.anchor(commentLabel.topAnchor, left: nil, bottom: nil, right: star5.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        commentTextView.anchor(commentLabel.bottomAnchor, left: commentTextView.leftAnchor, bottom: nil, right: characterCountLabel.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: self.view.frame.width - 20, heightConstant: self.view.frame.width / 2)
        
        
        let submitButtonConstant = (self.view.frame.width - 80) / 2
        submitButton.anchor(commentTextView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 15, leftConstant: submitButtonConstant, bottomConstant: 0, rightConstant: submitButtonConstant, widthConstant: 80, heightConstant: 50)

        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        commentTextView.resignFirstResponder()
    }
    
    @IBAction func rate1Star(_ sender: AnyObject) {
        starRating = 1
        star1.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star2.setBackgroundImage(#imageLiteral(resourceName: "star_unfilled"), for: .normal)
        star3.setBackgroundImage(#imageLiteral(resourceName: "star_unfilled"), for: .normal)
        star4.setBackgroundImage(#imageLiteral(resourceName: "star_unfilled"), for: .normal)
        star5.setBackgroundImage(#imageLiteral(resourceName: "star_unfilled"), for: .normal)
        
        animateStars(stars: [star1])
    }
    @IBAction func rate2Star(_ sender: AnyObject) {
        starRating = 2
        star1.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star2.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star3.setBackgroundImage(#imageLiteral(resourceName: "star_unfilled"), for: .normal)
        star4.setBackgroundImage(#imageLiteral(resourceName: "star_unfilled"), for: .normal)
        star5.setBackgroundImage(#imageLiteral(resourceName: "star_unfilled"), for: .normal)
        
        animateStars(stars: [star1, star2])
    }
    @IBAction func rate3Star(_ sender: AnyObject) {
        starRating = 3
        star1.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star2.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star3.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star4.setBackgroundImage(#imageLiteral(resourceName: "star_unfilled"), for: .normal)
        star5.setBackgroundImage(#imageLiteral(resourceName: "star_unfilled"), for: .normal)
        
        animateStars(stars: [star1, star2, star3])
    }

    @IBAction func rate4Star(_ sender: AnyObject) {
        starRating = 4
        star1.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star2.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star3.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star4.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star5.setBackgroundImage(#imageLiteral(resourceName: "star_unfilled"), for: .normal)
        
        animateStars(stars: [star1, star2, star3, star4])
    }
    @IBAction func rate5Star(_ sender: AnyObject) {
        starRating = 5
        star1.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star2.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star3.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star4.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        star5.setBackgroundImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        
        animateStars(stars: [star1, star2, star3, star4, star5])
    }
    
    func animateStars(stars: [UIButton]){
        for star in stars {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: { 
                star.frame.size = CGSize(width: star.frame.width * 1.1, height: star.frame.height * 1.1)
                }, completion: { (completed) in
                    //Bring back down
                    UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                        star.frame.size = CGSize(width: star.frame.width / 1.1, height: star.frame.height / 1.1)
                        }, completion: { (completed) in
                            //Do something?
                    })
            })
        }
    }
    
    
    @IBAction func submitRating(_ sender: AnyObject) {
        var comment = commentTextView.text
        var user = FIRAuth.auth()?.currentUser?.uid
        var username = FIRAuth.auth()?.currentUser?.displayName
        var rating = "\(starRating)"
        if comment == "Comment" {
            comment = ""
        }
        if invalidComment == true {
            alert = UIAlertController(title: "Too many characters", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if starRating == 0 {
            //Throw Alert
            alert = UIAlertController(title: "Select a rating", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            //Submit
            let newRating = Rating(user: user!, stadium: currentStadium, rating: rating, username: username!, comment: comment!)
            ratingsRef.childByAutoId().setValue(newRating.toAnyObject())
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        checkRemainingCharacters()
    }
    
    func checkRemainingCharacters(){
        let allowedCharacters = 60
        let charsInTextView = -commentTextView.text.characters.count
        let remainingCharacters = allowedCharacters + charsInTextView
        if remainingCharacters <= allowedCharacters {
            invalidComment = false
            characterCountLabel.textColor = UIColor.black
        }
        if remainingCharacters <= 20 {
            invalidComment = false
            characterCountLabel.textColor = UIColor.orange
        }
        if remainingCharacters <= 10 {
            invalidComment = false
            characterCountLabel.textColor = UIColor.red
        }
        if remainingCharacters < 0 {
            invalidComment = true
        }
        
        characterCountLabel.text = "\(remainingCharacters)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    /*
    //Load ratings and check for existing rating
    func loadStadiumRatings(){
        let ratingsRef = FIRDatabase.database().reference(withPath: "ratings").queryOrdered(byChild: "stadium").queryEqual(toValue: currentStadium)
        
        ratingsRef.observe(.value, with: { snapshot in
            for rating in snapshot.children {
                //Check if current user has existing rating
                let rate = rating as! FIRDataSnapshot
                if rate.childSnapshot(forPath: "user").value as? String == FIRAuth.auth()?.currentUser?.uid {
                    self.currentUserExistingRating = true
                }
                
            }
        })
    }
    */
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
