//
//  Client.swift
//  On the Map
//
//  Created by MacbookPRV on 04/05/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation


struct Student {
    
    //MARK: Properties

    var objectId:String
    var uniqueKey:String
    var firstName:String
    var lastName:String
    var mapString:String
    var mediaURL:String
    var latitude:Float
    var longitude:Float
    var createdAt:CFDate
    var updatedAt:CFDate
    
    //MARK: Initialisation

    init(dico : [String : AnyObject]) {
        
        if dico.count > 1 {
            
            objectId = dico["objectId"] as! String
            uniqueKey = dico["uniqueKey"] as! String
            firstName = dico["firstName"] as! String
            lastName = dico["lastName"] as! String
            mapString = dico["mapString"] as! String
            mediaURL = dico["mediaURL"] as! String
            latitude = dico["latitude"] as! Float
            longitude = dico["longitude"] as! Float
            createdAt = dico["createdAt"] as! CFDate
            updatedAt = dico["updatedAt"] as! CFDate
        }
        else {
            objectId = ""
            uniqueKey = ""
            firstName = ""
            lastName = ""
            mapString = ""
            mediaURL = ""
            latitude = 0.0
            longitude = 0.0
            createdAt = NSDate()
            updatedAt = NSDate()
            
        }
        
    }
    
}


 //MARK: Students Array
class Students {
    
    var studentsArray :[[String:AnyObject]]!
    static let sharedInstance = Students()
    
}

//MARK: Session


class Config {
    
    var sessionId : String!
    var accountKey : String!
    var latitude:Float!
    var longitude:Float!
    var mapString:String!
    
    static let sharedInstance = Config()
    
}



