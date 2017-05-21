//
//  BusStop.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation
import MapKit

class BusStop: Hashable {
    let ID: String
    let name: String
    
    let location: CLLocation
    
    init(ID: String, name: String, latitude: Double, longitude: Double) {
        self.ID = ID
        self.name = name
        
        location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
    static func ==(this: BusStop, that: BusStop) -> Bool {
        return this.ID == that.ID
    }
    
    var hashValue: Int {
        return ID.hashValue
    }
}
