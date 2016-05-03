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


    var varGlob:GlobalVariable!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        varGlob = GlobalVariable.sharedInstance
        
        

    }

    func LoardLocationData(completionHandlerLocation: (success: Bool, locations: [[String : AnyObject]]?) -> Void)
    {
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandlerLocation(success: false, locations: nil)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerLocation(success: false, locations: nil)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandlerLocation(success: false, locations: nil)
                return
                
            }
            
            
            /* Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                completionHandlerLocation(success: false, locations: nil)
                return
                
            }
            
            
            guard let result = parsedResult["results"] as? [[String : AnyObject]] else {
                print("Could not parse the data as JSON: '\(parsedResult)'")
                completionHandlerLocation(success: false, locations: nil)
                return
            }
            
            completionHandlerLocation(success: true, locations: result)
            
        }
        task.resume()
        
        
        
    }
    
    func RefreachData()  {
        
        
        self.LoardLocationData({(success, locations) in
            
            if success {
                self.varGlob.locations = locations
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            }
            
        })
        
        
    }
    
    

    
    @IBAction func ActionRefreach(sender: AnyObject) {
        
        self.RefreachData()
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseId = "Cell"
        let location =  varGlob.locations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId) as UITableViewCell!
        
        let first = location["firstName"] as! String
        let last = location["lastName"] as! String
        
        for view in cell.contentView.subviews {
            
            if view.tag == 99 {
                let firstlastname = view as! UILabel
                firstlastname.text =  "\(first)  \(last)"
            }
            
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return varGlob.locations.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let location = varGlob.locations[indexPath.row]
        if let url  = location["mediaURL"] as? String {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: url)!)
        }
    
    }
 
    
  
    
    
    @IBAction func ActionLogout(sender: AnyObject) {
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                
                return
                
            }
            
            /* subset response data! */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            /* Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
                
            }
            
            print(parsedResult)
            
            performUIUpdatesOnMain {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
        
        
        
        task.resume()
        
        
        
    }
    

    
}
