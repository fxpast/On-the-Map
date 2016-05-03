//
//  InfoPostViewController.swift
//  On the Map
//
//  Created by MacbookPRV on 02/05/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation

import UIKit

class InfoPostViewController : UIViewController {
    
    @IBOutlet weak var IBFirstName: UITextField!
    
    @IBOutlet weak var IBLastName: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.IBFirstName.text = ""
        self.IBLastName.text = ""
        
    }
    
    @IBAction func ActionCancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func ActionFindMap(sender: AnyObject) {
        
    }
    
    
}