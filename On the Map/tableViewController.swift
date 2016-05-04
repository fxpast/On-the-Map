//
//  tableViewController.swift
//  On the Map
//
//  Created by MacbookPRV on 03/05/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation

import UIKit


class tableViewController: UITableViewController {


    var config:Config!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        config = Config.sharedInstance
        //self.RefreshData()
        
        

    }

    
    func displayAlert(mess : String) {
        
        
        let alertController = UIAlertController(title: "Error", message: mess, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    
  private  func RefreshData()  {
        
        
        getLocations({(success, locations, errorString) in
            
            if success {
                self.config.locations = locations
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            }
            else {
                performUIUpdatesOnMain {
                    self.displayAlert(errorString!)
                }
            }
            
        })
        
        
    }
    
    

    
    @IBAction func ActionRefresh(sender: AnyObject) {
        
        self.RefreshData()
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseId = "Cell"
        let location =  config.locations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId) as UITableViewCell!
        let student = Student(dico: location)
      
        for view in cell.contentView.subviews {
            
            if view.tag == 99 {
                let firstlastname = view as! UILabel
                firstlastname.text =  "\(student.firstName)  \(student.lastName)"
            }
            
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.config.locations.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let location = config.locations[indexPath.row]
        let student = Student(dico: location)
        let app = UIApplication.sharedApplication()
        
        guard student.mediaURL != "" else {
            displayAlert("The student's link does not exist")
            return
        }
        
        app.openURL(NSURL(string: student.mediaURL)!)
       
    }
 
    
    
    
    
    
    @IBAction func ActionLogout(sender: AnyObject) {
        
        
        DeleteSession({(success, errorString) in
            
            
            if success {
                
                
                performUIUpdatesOnMain {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            }
            else {
                performUIUpdatesOnMain {
                    self.displayAlert(errorString!)
                }
            }
            
            
        })
        
    }
    
    
}
