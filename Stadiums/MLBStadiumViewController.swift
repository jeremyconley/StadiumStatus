//
//  MLBStadiumViewController.swift
//  Stadiums
//
//  Created by Jeremy Conley on 1/22/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class MLBStadiumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    var selectedTeamName = String()
    
    //Alert and Activity
    var alert = UIAlertController()
    
    //Stadium UID
    var selectedStadiumKey = String()
    
    //Cell height
    var commentIndex = [Int]()
    
    //Location
    let locationManager = CLLocationManager()
    var stadLatitude = Double()
    var stadLongitude = Double()
    

    @IBOutlet weak var starImgView: UIImageView!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var stadiumImage: UIImageView!
    
    @IBOutlet weak var numOfCheckedInLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    
    enum SportType {
        case baseball
        case football
    }
    var type: SportType?
    var sportType = String()
    
    //Team info
    var teams = [FIRDataSnapshot]()
    var currentTeam = FIRDataSnapshot()
    
    //Ratings Info
    let ratingsRef = FIRDatabase.database().reference(withPath: "ratings")
    var ratings = [FIRDataSnapshot]()
    var userHasRated = false
    
    //CheckIn Info
    let checkInsRef = FIRDatabase.database().reference(withPath: "checkIns")
    var checkIns = [FIRDataSnapshot]()
    var userIsChecked = false
    
    
    override func viewDidAppear(_ animated: Bool) {
        //Get ratings
        userIsChecked = false
        loadStadiumRatings()
        loadCheckIns()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        //Setup contraints
        setupViews()
        
        self.navigationController?.navigationBar.topItem!.title = ""
        
        
        //Setup Ratings Table
        ratingTableView.delegate = self
        ratingTableView.dataSource = self
        ratingTableView.allowsSelection = false
        
        //rateButton.layer.cornerRadius = 10
        
        //Get Current Stadium
        //if type == .baseball {
        if sportType == "Baseball" {
            let teamsRef = FIRDatabase.database().reference(withPath: "mlbStadiums").queryOrdered(byChild: "team").queryEqual(toValue: selectedTeamName)
            
            teamsRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
                self.currentTeam = snapshot
                self.navigationItem.title = self.currentTeam.childSnapshot(forPath: "name").value as? String
                self.loadStadiumInfo()
            }) { (error) in
                print(error.localizedDescription)
            }
            /*
            teamsRef.observe(.childAdded, with: { snapshot in
                self.currentTeam = snapshot
                self.navigationItem.title = self.currentTeam.childSnapshot(forPath: "name").value as? String
                self.loadStadiumInfo()
            })
            */
        } else {
            let teamsRef = FIRDatabase.database().reference(withPath: "nflStadiums").queryOrdered(byChild: "team").queryEqual(toValue: selectedTeamName)
            
            teamsRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
                self.currentTeam = snapshot
                self.navigationItem.title = self.currentTeam.childSnapshot(forPath: "name").value as? String
                self.loadStadiumInfo()
            }) { (error) in
                print(error.localizedDescription)
            }
            /*
            teamsRef.observe(.childAdded, with: { snapshot in
                self.currentTeam = snapshot
                self.navigationItem.title = self.currentTeam.childSnapshot(forPath: "name").value as? String
                self.loadStadiumInfo()
            })
            */
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        stadiumImage.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.view.frame.width - 100)
        stadiumImage.clipsToBounds = false
        stadiumImage.layer.shadowColor = UIColor.black.cgColor
        stadiumImage.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        stadiumImage.layer.shadowRadius = 3.0
        stadiumImage.layer.shadowOpacity = 1.0
        
        logoImageView.anchor(stadiumImage.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 75, heightConstant: 75)
        
        teamNameLabel.anchor(logoImageView.topAnchor, left: logoImageView.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        locationLabel.anchor(teamNameLabel.bottomAnchor, left: teamNameLabel.leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        leagueLabel.anchor(locationLabel.bottomAnchor, left: teamNameLabel.leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        checkInButton.anchor(logoImageView.bottomAnchor, left: logoImageView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 82, heightConstant: 30)
        
        numOfCheckedInLabel.anchor(checkInButton.bottomAnchor, left: checkInButton.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        ratingTableView.anchor(numOfCheckedInLabel.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        starImgView.anchor(logoImageView.topAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 30, heightConstant: 30)
        
        averageRatingLabel.anchor(starImgView.topAnchor, left: nil, bottom: nil, right: starImgView.leftAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        rateButton.anchor(checkInButton.topAnchor, left: nil, bottom: nil, right: starImgView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 46, heightConstant: 30)
        
        rateButton.alpha = 0
        starImgView.alpha = 0
        ratingTableView.alpha = 0
        rateButton.alpha = 0
        checkInButton.alpha = 0
        leagueLabel.alpha = 0
        locationLabel.alpha = 0
        teamNameLabel.alpha = 0
        logoImageView.alpha = 0
        stadiumImage.alpha = 0
        numOfCheckedInLabel.alpha = 0
        averageRatingLabel.alpha = 0
        
        animateViews()
        
        
    }
    
    func animateViews(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: { 
            self.rateButton.alpha = 1
            self.starImgView.alpha = 1
            self.ratingTableView.alpha = 1
            self.rateButton.alpha = 1
            self.checkInButton.alpha = 1
            self.leagueLabel.alpha = 1
            self.locationLabel.alpha = 1
            self.teamNameLabel.alpha = 1
            self.logoImageView.alpha = 1
            self.stadiumImage.alpha = 1
            self.numOfCheckedInLabel.alpha = 1
            self.averageRatingLabel.alpha = 1
            }) { (animCompleted) in
                //
        }
    }
    
    func loadStadiumInfo(){
        var teamLeague = ""
        let stadiumPicURL = currentTeam.childSnapshot(forPath: "stadiumpicDownloadURL").value as! String
        let teamPicURL = currentTeam.childSnapshot(forPath: "teampicDownloadURL").value as! String
        let stadiumLocation = currentTeam.childSnapshot(forPath: "location").value as! String
        let lat = currentTeam.childSnapshot(forPath: "lat").value as? NSString
        stadLatitude = (lat?.doubleValue)!
        let long = currentTeam.childSnapshot(forPath: "long").value as? NSString
        stadLongitude = (long?.doubleValue)!
        if let league = currentTeam.childSnapshot(forPath: "league").value as? String {
            teamLeague = league
        } else {
            teamLeague = currentTeam.childSnapshot(forPath: "conference").value as! String
        }
        
        
        
        selectedStadiumKey = currentTeam.key
        
        //Download Team and Stadium Picture
        stadiumImage.loadImgUsingCacheWithUrlString(urlString: stadiumPicURL)
        logoImageView.loadImgUsingCacheWithUrlString(urlString: teamPicURL)
        
        //Update info
        teamNameLabel.text = selectedTeamName
        locationLabel.text = stadiumLocation
        leagueLabel.text = teamLeague
        
    }
    
    func loadStadiumRatings(){
        let ratingsRef = FIRDatabase.database().reference(withPath: "ratings").queryOrdered(byChild: "stadium").queryEqual(toValue: selectedStadiumKey)
        
        ratingsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.ratings.removeAll()
            for rating in snapshot.children {
                self.ratings.append(rating as! FIRDataSnapshot)
                let rate = rating as! FIRDataSnapshot
                if rate.childSnapshot(forPath: "user").value as? String == FIRAuth.auth()?.currentUser?.uid {
                    self.userHasRated = true
                }
            }
            self.ratings.reverse()
            self.ratingTableView.reloadData()
            self.commentIndex.removeAll()
            self.averageStadiumRating()
        }) { (error) in
            print(error.localizedDescription)
        }
        /*
        ratingsRef.observe(.value, with: { snapshot in
            self.ratings.removeAll()
            for rating in snapshot.children {
                self.ratings.append(rating as! FIRDataSnapshot)
                let rate = rating as! FIRDataSnapshot
                if rate.childSnapshot(forPath: "user").value as? String == FIRAuth.auth()?.currentUser?.uid {
                    self.userHasRated = true
                }
            }
            self.ratings.reverse()
            self.ratingTableView.reloadData()
            self.commentIndex.removeAll()
            self.averageStadiumRating()
        })
        */
    }
    
    func averageStadiumRating(){
        var totalStars = 0.0
        for rate in ratings {
            let rating = rate.childSnapshot(forPath: "rating").value as? String
            totalStars += Double(rating!)!
        }
        if ratings.count > 0 {
            var avgRating = totalStars / Double(ratings.count)
            let rateInt = Int(avgRating.rounded())
            self.averageRatingLabel.text = "\(rateInt)"
        } else {
            //No ratings
            self.averageRatingLabel.text = "0"
        }
        
    }
    
    func loadCheckIns(){
        let checkinRef = FIRDatabase.database().reference(withPath: "checkIns").queryOrdered(byChild: "stadiumId").queryEqual(toValue: selectedStadiumKey)
        
        checkinRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.checkIns.removeAll()
            for checkIn in snapshot.children {
                let check = checkIn as! FIRDataSnapshot
                let date = check.childSnapshot(forPath: "checkInDate").value as? String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                let dateObj = dateFormatter.date(from: date!)
                let currentDate = NSDate()
                
                var distanceBetweenDates = currentDate.timeIntervalSince(dateObj!)
                let hoursBetweenDates = (distanceBetweenDates/3600)
                if hoursBetweenDates > 4 {
                    //Check in expired, Don't add it to the list
                    //check.ref.removeValue()
                } else {
                    //Still Checked
                    self.checkIns.append(check)
                }
            }
            self.numOfCheckedInLabel.text = "\(self.checkIns.count)" + " " + "fans here"
        }) { (error) in
            print(error.localizedDescription)
        }
        /*
        checkinRef.observe(.value, with: { snapshot in
            self.checkIns.removeAll()
            for checkIn in snapshot.children {
                let check = checkIn as! FIRDataSnapshot
                let date = check.childSnapshot(forPath: "checkInDate").value as? String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                let dateObj = dateFormatter.date(from: date!)
                let currentDate = NSDate()
                
                var distanceBetweenDates = currentDate.timeIntervalSince(dateObj!)
                let hoursBetweenDates = (distanceBetweenDates/3600)
                if hoursBetweenDates > 4 {
                    //Check in expired, Don't add it to the list
                    //check.ref.removeValue()
                } else {
                    //Still Checked
                    self.checkIns.append(check)
                }
            }
            self.numOfCheckedInLabel.text = "\(self.checkIns.count)" + " " + "fans here"
        })
        */
    }
    
    //Alert Functions
    func alreadyRatedAlert(){
        alert = UIAlertController(title: "Already Rated", message: "You have already rated this stadium.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkInSuccesAlert(){
        alert = UIAlertController(title: "Checked In!", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkInDistanceAlert(distanceAway: Double){
        locationManager.stopUpdatingLocation()
        alert = UIAlertController(title: "Out of Range", message: "You are " + "\(distanceAway)" + " miles too far away", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkInErrorAlert(){
        alert = UIAlertController(title: "Failed to Check in", message: "Update location privacy settings", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alreadyCheckedInAlert(){
        alert = UIAlertController(title: "Already Checked In", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ratingTableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath)
        let rating = ratings[indexPath.row]
        
        
        let rateUserId = rating.childSnapshot(forPath: "user").value as? String
        
        let numOfStars = rating.childSnapshot(forPath: "rating").value as? String
        let rateUsername = rating.childSnapshot(forPath: "username").value as? String
        let rateComment = rating.childSnapshot(forPath: "comment").value as? String
        if rateComment != "" {
            commentIndex.append(indexPath.row)
        }
        
        let usernameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let ratingLabel = cell.contentView.viewWithTag(2) as! UILabel
        let commentLabel = cell.contentView.viewWithTag(3) as! UILabel
        let starImg = cell.contentView.viewWithTag(4) as! UIImageView
        
        starImg.anchor(cell.topAnchor, left: nil, bottom: nil, right: cell.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 20, heightConstant: 20)
        ratingLabel.anchor(starImg.topAnchor, left: nil, bottom: nil, right: starImg.leftAnchor, topConstant: -2, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 25, heightConstant: 27)
        
        usernameLabel.text = rateUsername
        ratingLabel.text = numOfStars
        commentLabel.text = rateComment
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 44
        if commentIndex.contains(indexPath.row){
            cellHeight = 88
        }
        return cellHeight
    }
    
    
    //Rate Button Action
    @IBAction func rateStadium(_ sender: AnyObject) {
        if userHasRated == false {
            if let user = FIRAuth.auth()?.currentUser {
                self.performSegue(withIdentifier: "rateSegue", sender: self)
                //Rate the Stadium
                //let rating = Rating(user: (FIRAuth.auth()?.currentUser?.uid)!, stadium: currentTeam.key, rating: 4)
            } else {
                //Sign in
                self.performSegue(withIdentifier: "logIn", sender: self)
            }
        } else {
            alreadyRatedAlert()
        }
    }
    
    //Check in Button Action
    @IBAction func checkInAction(_ sender: AnyObject) {
        if let user = FIRAuth.auth()?.currentUser {
            checkForExistingCheckin()
        } else {
            //Sign in
            self.performSegue(withIdentifier: "logIn", sender: self)
        }
    }
    
    //Check for already checked in
    func checkForExistingCheckin() {
        if checkIns.count > 0 {
            var checkInExists = false;
            for check in checkIns {
                if check.childSnapshot(forPath: "userId").value as? String == FIRAuth.auth()?.currentUser?.uid {
                    //Already Checked In
                    self.alreadyCheckedInAlert()
                    return
                }
            }
            self.checkAuthorization()
        } else {
            self.checkAuthorization()
        }
    }
    
    //Check user location settings
    func checkAuthorization(){
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .restricted, .denied:
                checkInErrorAlert()
                print("No access")
                
            case .authorizedAlways, .authorizedWhenInUse:
                checkIn()
                print("Access")
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            print("Location services are not enabled")
            //checkInErrorAlert()
            
        }
    }
    
    //Check in using CLLocation
    func checkIn(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Check if user is in range of stadium
        let currLocation = locationManager.location?.coordinate
        let currentLong = currLocation?.longitude
        let currentLat = currLocation?.latitude
        
        checkDistance(lat1: currentLat!, long1: currentLong!)
        
    }
    
    //Check if user is in range of stadium
    func checkDistance(lat1:Double, long1: Double){
        let lat1Radians = lat1.degreesToRadians
        let lat2Radians = stadLatitude.degreesToRadians
        
        var R: Double = 3959 // km
        var dLat = (stadLatitude - lat1).degreesToRadians
        var dLon = (stadLongitude-long1).degreesToRadians
        
        var dLatDivided = sin(dLat/2)
        var dLongDivided = sin(dLon/2)
        var cosLat1 = cos(lat1Radians)
        var cosLat2 = cos(lat2Radians)
        
        var a = dLatDivided * dLatDivided +
            dLongDivided * dLongDivided * cosLat1 * cosLat2
        var c = 2 * atan2(sqrt(a), sqrt(1-a))
        var d = R * c
        
        if d <= 5 {
            checkInSuccess()
        } else {
           checkInDistanceAlert(distanceAway: round(10 * d) / 10)
        }
        
    }
    
    func checkInSuccess(){
        let checkInDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateString = dateFormatter.string(from:checkInDate as Date)
        
        let checkIn = CheckIn(userId: (FIRAuth.auth()?.currentUser?.uid)!, stadiumId: selectedStadiumKey, checkInDate: dateString)
        checkInsRef.childByAutoId().setValue(checkIn.toAnyObject())
        checkInSuccesAlert()
        loadCheckIns()
    }
    
    func checkInWithCoordinates(location: CLLocationCoordinate2D){
        print(location)
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //checkInWithCoordinates(location: (locations.last?.coordinate)!)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rateSegue"{
            let rateVC = segue.destination as! RatingViewController
            rateVC.currentStadium = selectedStadiumKey
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
