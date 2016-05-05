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

class InfoPostViewController : UIViewController , MKMapViewDelegate {
    
    
    
    @IBOutlet weak var IBWhere: UILabel!
    @IBOutlet weak var IBFind: UIButton!
    @IBOutlet weak var IBSubmit: UIButton!
    @IBOutlet weak var IBMap: MKMapView!
    @IBOutlet weak var IBUrl: UITextField!
    @IBOutlet weak var IBInfoLocation: UITextField!
    @IBOutlet weak var IBActivity: UIActivityIndicatorView!
    
    var config:Config!
    var student:Student!
    
    //MARK: View Controller Delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config = Config.sharedInstance
        IBActivity.hidden = true
        student = Student(dico:[String:AnyObject]())
        IBMap.delegate = self
        
        setUIHidden(true)
        
        
        
        
    }
    
    @IBAction func ActionCancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    private func setUIHidden(hidden: Bool) {
        
        IBUrl.hidden = hidden
        IBMap.hidden = hidden
        IBSubmit.hidden = hidden
        
        IBWhere.hidden = !hidden
        IBFind.hidden = !hidden
        IBInfoLocation.hidden = !hidden
        
        
    }
    
    
    
    //MARK: Data Networking
    
    
    @IBAction func ActionSubmit(sender: AnyObject) {
        
        IBActivity.hidden = false
        IBActivity.startAnimating()
        
        guard IBUrl.text != "" else {
            
            self.IBActivity.stopAnimating()
            self.IBActivity.hidden = true
            displayAlert("Error, You have to paste or Tape in the link")
            return
        }
        
        student.mediaURL = self.IBUrl.text!
        
        PostLocation(student, completionHandlerPostLocation: {(success, errorString) in
            
            self.IBActivity.stopAnimating()
            self.IBActivity.hidden = true
            
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
    
    
    
    private func loadData()  {
        
        
        getUserData(config.accountKey, completionHandlerForUser:{(success, results, errorString) in
            
            
            self.IBActivity.stopAnimating()
            self.IBActivity.hidden = true
            
            
            if success {
                
                performUIUpdatesOnMain {
                    
                    self.IBUrl.text = results!["linkedin_url"] as? String
                    if self.IBUrl.text == "" { self.IBUrl.text = results!["website_url"] as? String }
                    self.student.uniqueKey = results!["key"] as! String
                    self.student.firstName = results!["first_name"] as! String
                    self.student.lastName = results!["last_name"] as! String
                    self.student.mapString = self.config.mapString
                    self.student.mediaURL = self.IBUrl.text!
                    self.student.latitude = self.config.latitude
                    self.student.longitude = self.config.longitude
                    
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(self.student.latitude)
                    let long = CLLocationDegrees(self.student.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(self.student.firstName) \(self.student.lastName)"
                    annotation.subtitle = self.student.mediaURL
                    
                    self.IBMap.addAnnotation(annotation)
                    
                }
                
            }
            else {
                performUIUpdatesOnMain {
                    self.displayAlert(errorString!)
                }
            }
            
        })
        
        
        
    }
    
    
    
    @IBAction func ActionFindMap(sender: AnyObject) {
        
        setUIHidden(false)
        
        IBActivity.hidden = false
        IBActivity.startAnimating()
        config.mapString = IBInfoLocation.text
        
        let geoCode  = CLGeocoder()
        
        
        geoCode.geocodeAddressString(IBInfoLocation.text!, completionHandler: {(marks,error) in
            
            guard error == nil else {
                performUIUpdatesOnMain {
                    
                    self.setUIHidden(true)
                    self.IBActivity.stopAnimating()
                    self.IBActivity.hidden = true
                    self.displayAlert("error geocodeadresse : \(error.debugDescription)")
                }
                return
            }
            
            let placemark = marks![0] as CLPlacemark
            self.config.latitude = Float((placemark.location?.coordinate.latitude)!)
            self.config.longitude = Float((placemark.location?.coordinate.longitude)!)
            
            performUIUpdatesOnMain {
                self.loadData()
                
            }
            
        })
        
        
    }
    
    
    
    //MARK: Map View Delegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            
            guard IBUrl.text != "" else {
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
    
    
}