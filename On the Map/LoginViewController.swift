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
    @IBOutlet weak var IBLogin: UIButton!
    
    @IBAction func ActionLogin(sender: AnyObject) {
        
        
        guard self.IBEmail.text != "" else {
            
            displayAlert("Error, Email is empty")
            return
        }
        
        
        guard self.IBPassword.text != "" else {
            
            displayAlert( "Error, password is empty")
            return
        }
        
        self.setUIEnabled(false)
        
        getSessionID(self.IBEmail.text, password: self.IBPassword.text, completionHandlerForSession: {(success, accountKey, sessionId, errorString) in
        
            
            
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
            }
            
        
            if success {
                
                performUIUpdatesOnMain {
                    
                    var config = Config.sharedInstance
                    config.accountKey = accountKey
                    config.sessionId = sessionId
                    self.IBPassword.text = ""
                    self.performSegueWithIdentifier("tabbar", sender: self)
                }
                

                
            }
            else {
                performUIUpdatesOnMain {
                    self.displayAlert(errorString!)
                }
            }
            
        
        })
        
        
    }
    
    
  private func displayAlert(mess : String) {
        
        
        let alertController = UIAlertController(title: "Error", message: mess, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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