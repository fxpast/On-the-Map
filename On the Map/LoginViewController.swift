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
    
    
    
    private func setUIEnabled(enabled: Bool) {
        IBEmail.enabled = enabled
        IBPassword.enabled = enabled
        IBLogin.enabled = enabled
        // adjust login button alpha
        if enabled {
            IBLogin.alpha = 1.0
        } else {
            IBLogin.alpha = 0.5
        }
        
        
    }
    
    
    //MARK: Sign in
    @IBAction func ActionLogin(sender: AnyObject) {
        
        
        guard IBEmail.text != "" else {
            
            displayAlert("Error, Email is empty")
            return
        }
        
        
        guard IBPassword.text != "" else {
            
            displayAlert( "Error, password is empty")
            return
        }
        
        setUIEnabled(false)
        
        getSessionID(IBEmail.text, password: IBPassword.text, completionHandlerForSession: {(success, accountKey, sessionId, errorString) in
        
            
            
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
            }
            
        
            if success {
                
                performUIUpdatesOnMain {
                    
                    let config = Config.sharedInstance
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
    
    
    
    
    @IBAction func ActionFaceBook(sender: AnyObject) {
        
        
        
    }
    
    
    //MARK: Sign up
    @IBAction func ActionSingUp(sender: AnyObject) {
        
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        
    }
    
    
    
    
    
    
}