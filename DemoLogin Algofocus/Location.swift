//
//  Location.swift
//  DemoLogin Algofocus
//
//  Created by Chaudhary Himanshu Raj on 03/01/18.
//  Copyright © 2018 Chaudhary Himanshu Raj. All rights reserved.
//

import Foundation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude : Double!
    var longitude : Double!
}
