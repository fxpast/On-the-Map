//
//  InfoPostViewController.swift
//  On the Map
//
//  Created by MacbookPRV on 02/05/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation

import MapKit
import UIKit

class InfoPostViewController : UIViewController {
    
  
    @IBOutlet weak var IBInfoLocation: UITextField!
    @IBOutlet weak var IBActivity: UIActivityIndicatorView!
     var config:Config!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config = Config.sharedInstance
        self.IBActivity.hidden = true
                
    }
    
    @IBAction func ActionCancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    private func displayAlert(mess : String) {
        
        
        let alertController = UIAlertController(title: "Error", message: mess, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func ActionFindMap(sender: AnyObject) {
        
        self.IBActivity.hidden = false
        self.IBActivity.startAnimating()
        self.config.mapString = self.IBInfoLocation.text
        
        let geoCode  = CLGeocoder()
        
        
        geoCode.geocodeAddressString(self.IBInfoLocation.text!, completionHandler: {(marks,error) in
        
            guard error == nil else {
                self.displayAlert("error geocodeadresse : \(error.debugDescription)")
                return
            }
            
             let placemark = marks![0] as CLPlacemark
             self.config.latitude = Float((placemark.location?.coordinate.latitude)!)
             self.config.longitude = Float((placemark.location?.coordinate.longitude)!)
            
            performUIUpdatesOnMain {
                self.IBActivity.stopAnimating()
                self.IBActivity.hidden = true
                self.performSegueWithIdentifier("fromPostView", sender: self)
            }
            

            
        
        })
       
        
    }
    
    
}