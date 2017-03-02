//
//  NFLTableViewController.swift
//  Stadiums
//
//  Created by Jeremy Conley on 1/22/17.
//  Copyright © 2017 JeremyConley. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NFLTableViewController: UITableViewController {
    
    let nflTeamsRef = FIRDatabase.database().reference(withPath: "nflStadiums")
    var teams = [FIRDataSnapshot]()
    
    var selectedTeamName = String()
    
    //Setup nav image
    let nflImg = UIImage(named: "nflNavImg.png")
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup nav image
        let nflImgView = UIImageView(image: nflImg)
        nflImgView.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        nflImgView.contentMode = .scaleAspectFit
        containerView.addSubview(nflImgView)
        
        self.navigationItem.titleView = containerView
        
        nflTeamsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //self.posts.removeAll()
            for item in snapshot.children{
                self.teams.append(item as! FIRDataSnapshot)
            }
            //self.posts.reverse()
            self.tableView.reloadData()
            print(self.teams.count)
        }) { (error) in
            print(error.localizedDescription)
        }

        /*
        nflTeamsRef.observe(.value, with: { snapshot in
            //self.posts.removeAll()
            for item in snapshot.children{
                self.teams.append(item as! FIRDataSnapshot)
            }
            //self.posts.reverse()
            self.tableView.reloadData()
            print(self.teams.count)
        })
        */

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return teams.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nflCell", for: indexPath)
        
        //Cell label and Image
        let teamNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let teamNamePic = cell.contentView.viewWithTag(2) as! UIImageView
        teamNamePic.contentMode = .scaleAspectFit
        
        let team = teams[indexPath.row]
        let teamName = team.childSnapshot(forPath: "team").value as! String
        let teamPicURL = team.childSnapshot(forPath: "teampicDownloadURL").value as! String
        
        teamNameLabel.text = teamName
        
        //Download Team Picture
        teamNamePic.loadImgUsingCacheWithUrlString(urlString: teamPicURL)
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nflStadiumSegue"{
            let indexPath = tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
            let teamTextLabel = currentCell.contentView.viewWithTag(1) as! UILabel
            selectedTeamName = teamTextLabel.text!
            
            let stadiumVC = segue.destination as! MLBStadiumViewController
            stadiumVC.selectedTeamName = selectedTeamName
            stadiumVC.sportType = "Football"
            print(selectedTeamName)
            
        }
    }
    

}
