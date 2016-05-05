//
//  LoginViewController.swift
//  On the Map
//
//  Created by MacbookPRV on 02/05/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var IBEmail: UITextField!
    @IBOutlet weak var IBPassword: UITextField!
    @IBOutlet weak var IBLogin: UIButton!
    @IBOutlet weak var IBFacebook: UIButton!
    
    var facebookButton:FBSDKLoginButton!
    
    
    //MARK: View Controller Delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IBEmail.delegate = self
        IBPassword.delegate = self
        
        loginWithCurrentToken()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        facebookButton = FBSDKLoginButton()
        view.addSubview(facebookButton)
        
        facebookButton.frame = IBFacebook.frame
        facebookButton.center = IBFacebook.center
        IBFacebook.hidden = true
        
        facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookButton.delegate = self
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
        
    }
    
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
    
    //MARK: Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User facebook Logged In")
        
        if ((error) != nil)
        {
            // Process error
            displayAlert(error.debugDescription)
        }
        else if result.isCancelled {
            // Handle cancellations
            print("log in is cancelled")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                LoadFaceBook(FBSDKAccessToken.currentAccessToken().tokenString)
                self.IBEmail.hidden = true
                self.IBPassword.hidden = true
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User facebook Logged Out")
        loginWithCurrentToken()
    }
    
    
    //MARK: Sign in
    
    
    @IBAction func ActionLogin(sender: AnyObject) {
        
        
        if loginWithCurrentToken() {
            return
        }
        
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
    
    
    private func loginWithCurrentToken() -> Bool {
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in
            IBEmail.hidden = true
            IBPassword.hidden = true
            LoadFaceBook(FBSDKAccessToken.currentAccessToken().tokenString)
            return true
        }
        else {
            
            IBEmail.hidden = false
            IBPassword.hidden = false
            return false
        }
        
        
    }
    
    
    
    private func LoadFaceBook(token:String) {
        
        getFaceBookSession(token) { (success, accountKey, sessionId, errorString) in
            
            if success {
                
                performUIUpdatesOnMain {
                    
                    let config = Config.sharedInstance
                    config.accountKey = accountKey
                    config.sessionId = sessionId
                    self.performSegueWithIdentifier("tabbar", sender: self)
                }
                
            }
            else {
                performUIUpdatesOnMain {
                    self.displayAlert(errorString!)
                }
            }
            
        }
        
    }
    
    
    
    //MARK: Sign up
    @IBAction func ActionSingUp(sender: AnyObject) {
        
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        
    }
    
    
    
    
    
    
}