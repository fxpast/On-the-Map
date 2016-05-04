//
//  ViewController.swift
//  On the Map
//
//  Created by MacbookPRV on 28/04/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//


import Foundation

import MapKit

import UIKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var IBMap: MKMapView!
    
    
    var accountKey:String!
    var sessionId:String!
    var config:Config!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        config = Config.sharedInstance
        self.IBMap.delegate = self
        
        self.accountKey  = config.accountKey
        self.sessionId = config.sessionId
        self.RefreshData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ActionRefresh(sender: AnyObject) {
        
        self.RefreshData()
    }
    
    
    private func RefreshData()  {
        
        let annoArray = self.IBMap.annotations as [AnyObject]
        for item in annoArray {
            self.IBMap.removeAnnotation(item as! MKAnnotation)
        }
        
        getLocations({(success, locations, errorString) in
            
            if success {
                
                self.config.locations = locations
                
                var annotations = [MKPointAnnotation]()
                
                for dictionary in self.config.locations! {
                    
                    let student = Student(dico: dictionary)
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(student.latitude)
                    let long = CLLocationDegrees(student.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(student.firstName) \(student.lastName)"
                    annotation.subtitle = student.mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                
                
                performUIUpdatesOnMain {
                    self.IBMap.addAnnotations(annotations)
                }
                
            }
            else {
                performUIUpdatesOnMain {
                    self.displayAlert(errorString!)
                }
            }

            
            
        })
        
        
    }
    
    
    
    func displayAlert(mess : String) {
        
        
        let alertController = UIAlertController(title: "Error", message: mess, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        

        self.presentViewController(alertController, animated: true, completion: nil)
        
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
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    
    
}

