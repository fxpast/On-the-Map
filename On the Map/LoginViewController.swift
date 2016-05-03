//
//  LoginViewController.swift
//  On the Map
//
//  Created by MacbookPRV on 02/05/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation

import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var IBEmail: UITextField!
    @IBOutlet weak var IBPassword: UITextField!
    @IBOutlet weak var IBMessage: UILabel!
    @IBOutlet weak var IBLogin: UIButton!
    
    @IBAction func ActionLogin(sender: AnyObject) {
        
        self.IBMessage.text = ""
        
        guard self.IBEmail.text != "" else {
            
            self.IBMessage.text = "Error, Email is empty"
            return
        }
        
        
        guard self.IBPassword.text != "" else {
            
            self.IBMessage.text = "Error, password is empty"
            return
        }
        
        self.setUIEnabled(false)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody  = "{\"udacity\": {\"username\": \"\(self.IBEmail.text!)\", \"password\": \"\(self.IBPassword.text!)\"}}"
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            
            performUIUpdatesOnMain {                
                self.setUIEnabled(true)
            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                performUIUpdatesOnMain {
                    self.IBMessage.text = "There was an error with your request: \(error)"
                }
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                performUIUpdatesOnMain {
                    self.IBMessage.text = "Your request returned a status code other than 2xx!"
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                performUIUpdatesOnMain {
                    self.IBMessage.text =  "No data was returned by the request!"
                }
                return
                
            }
            
            /* subset response data! */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            /* Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                performUIUpdatesOnMain {
                    self.IBMessage.text = "Could not parse the data as JSON: '\(newData)'"
                }
                return
                
            }
            
            let dicoAccount = parsedResult["account"] as! [String:AnyObject]
            let dicoSession = parsedResult["session"] as! [String:AnyObject]
            
            let accountKey = dicoAccount["key"] as! String
            let sessionId = dicoSession["id"] as! String
            
            
            print(parsedResult)
            performUIUpdatesOnMain {
                
                let varGlob = GlobalVariable.sharedInstance
                varGlob.accountKey = accountKey
                varGlob.sessionId = sessionId
                self.IBPassword.text = ""
                self.performSegueWithIdentifier("tabbar", sender: self)
            }
            
            
        }
        task.resume()
        
        
    }
    
    
    
    private func setUIEnabled(enabled: Bool) {
        self.IBEmail.enabled = enabled
        self.IBPassword.enabled = enabled
        self.IBLogin.enabled = enabled
        // adjust login button alpha
        if enabled {
            self.IBLogin.alpha = 1.0
        } else {
            self.IBLogin.alpha = 0.5
        }
        
        
    }
    
    
    @IBAction func ActionSingUp(sender: AnyObject) {
        
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        
    }
    
    
    
    @IBAction func ActionFaceBook(sender: AnyObject) {
    }
    
    
    
    
    
}