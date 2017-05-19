//
//  BusStop.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation
import MapKit

class BusStop: Equatable, Hashable {
    let ID: String
    let name: String
    
    let location: CLLocationCoordinate2D
    
    init(ID: String, name: String, lat: Double, lon: Double) {
        self.ID = ID
        self.name = name
        
        location = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
    }
    
    static func ==(this: BusStop, that: BusStop) -> Bool {
        return this.ID == that.ID
    }
    
    var hashValue: Int {
        return ID.hashValue
    }
}
