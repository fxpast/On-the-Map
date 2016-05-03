//
//  GlobalVariable.swift
//  On the Map
//
//  Created by MacbookPRV on 03/05/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation

class GlobalVariable {
    
    var sessionId : String!
    var accountKey : String!
    var locations :[[String:AnyObject]]!
    
    
    static let sharedInstance = GlobalVariable()
    
}