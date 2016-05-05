//
//  tableViewController.swift
//  On the Map
//
//  Created by MacbookPRV on 03/05/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation
import UIKit


class TableViewController: UITableViewController {
    
    var students:Students!
    
    
    //MARK: View Controller Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        students = Students.sharedInstance
    }
    
    
    //MARK: Data Networking
    private  func RefreshData()  {
        getLocations({(success, locations, errorString) in
            
            if success {
                self.students.studentsArray = locations
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
        
        RefreshData()
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
    
    
    //MARK: Table View Controller Delegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseId = "Cell"
        let location =  students.studentsArray[indexPath.row]
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
        return students.studentsArray.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let location = students.studentsArray[indexPath.row]
        let student = Student(dico: location)
        let app = UIApplication.sharedApplication()
        
        guard student.mediaURL != "" else {
            displayAlert("The student's link does not exist")
            return
        }
        
        guard let url = NSURL(string: student.mediaURL) else {
            displayAlert("invalid link")
            return
        }
        app.openURL(url)
        
    }
    
    
}
