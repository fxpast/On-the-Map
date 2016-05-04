//
//  GCDBlackBox.swift
//  On the Map
//
//  Created by MacbookPRV on 03/05/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//


import Foundation

import UIKit


func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}



