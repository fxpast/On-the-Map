//
//  Client.swift
//  On the Map
//
//  Created by MacbookPRV on 04/05/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation

struct Student {
    
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
    
    init(dico : [String : AnyObject]) {
        self.objectId = dico["objectId"] as! String
        self.uniqueKey = dico["uniqueKey"] as! String
        self.firstName = dico["firstName"] as! String
        self.lastName = dico["lastName"] as! String
        self.mapString = dico["mapString"] as! String
        self.mediaURL = dico["mediaURL"] as! String
        self.latitude = dico["latitude"] as! Float
        self.longitude = dico["longitude"] as! Float
        self.createdAt = dico["createdAt"] as! CFDate
        self.updatedAt = dico["updatedAt"] as! CFDate
        
    }
    
}


class Config {
    
    var sessionId : String!
    var accountKey : String!
    var latitude:Float!
    var longitude:Float!
    var mapString:String!
    var locations :[[String:AnyObject]]!
    
    
    static let sharedInstance = Config()
    
}




func getSessionID(mail: String?, password: String?, completionHandlerForSession: (success: Bool, accountKey: String?, sessionId: String?, errorString: String?) -> Void) {


    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let jsonBody  = "{\"udacity\": {\"username\": \"\(mail!)\", \"password\": \"\(password!)\"}}"
    request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            completionHandlerForSession(success: false, accountKey: nil, sessionId: nil, errorString: "Your request returned error : \(error!.debugDescription)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            completionHandlerForSession(success: false, accountKey: nil, sessionId: nil, errorString: "Your request returned a status code other than 2xx!, error : \(response.debugDescription)")
            
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            
             completionHandlerForSession(success: false, accountKey: nil, sessionId: nil, errorString: "No data was returned by the request!")
            
            return
            
        }
        
        /* subset response data! */
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        
        /* Parse the data */
        let parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            completionHandlerForSession(success: false, accountKey: nil, sessionId: nil, errorString: "Could not parse the data as JSON: '\(newData)'")
            
            return
            
        }
        
        let dicoAccount = parsedResult["account"] as! [String:AnyObject]
        let dicoSession = parsedResult["session"] as! [String:AnyObject]
        
        let accountKey = dicoAccount["key"] as! String
        let sessionId = dicoSession["id"] as! String
        
        completionHandlerForSession(success: true, accountKey: accountKey, sessionId: sessionId, errorString: nil)
       
        
        
    }
    task.resume()
    
    
    
    
}




func DeleteSession(completionHandlerDeleteSession: (success: Bool, errorString: String?) -> Void) {

    
    
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
            completionHandlerDeleteSession(success: false, errorString: "There was an error with your request: \(error)")
            
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            completionHandlerDeleteSession(success: false, errorString: "Your request returned a status code other than 2xx!, error : \(response.debugDescription)")
            
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            completionHandlerDeleteSession(success: false, errorString:"No data was returned by the request!")
            
            return
            
        }
        
        /* subset response data! */
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        /* Parse the data */
        
        do {
           _ = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            
            completionHandlerDeleteSession(success: false, errorString:"Could not parse the data as JSON: '\(newData)'")
            
            return
            
        }
        
        completionHandlerDeleteSession(success: true, errorString: nil)
        
    }
    
    
    
    task.resume()
    

    
}





func getLocations(completionHandlerLocation: (success: Bool, locations: [[String : AnyObject]]?, errorString:String?) -> Void)
{
    
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt")!)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    let session = NSURLSession.sharedSession()
    
    let task = session.dataTaskWithRequest(request) { data, response, error in
        
        
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
           
            completionHandlerLocation(success: false, locations: nil, errorString: "There was an error with your request: \(error)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            completionHandlerLocation(success: false, locations: nil, errorString: "Your request returned a status code other than 2xx!, error : \(response.debugDescription)")
            
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
           
            completionHandlerLocation(success: false, locations: nil, errorString: "No data was returned by the request!")
            return
            
        }
        
        
        /* Parse the data */
        let parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            
            completionHandlerLocation(success: false, locations: nil, errorString: "Could not parse the data as JSON: '\(data)'")
            return
            
        }
        
        
        guard let result = parsedResult["results"] as? [[String : AnyObject]] else {
            
            completionHandlerLocation(success: false, locations: nil, errorString: "Could not parse the data as JSON: '\(parsedResult)'")
            return
        }
        
        completionHandlerLocation(success: true, locations: result, errorString: nil)
        
    }
    task.resume()
    
    
    
}