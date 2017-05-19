//
//  BusStop.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class BusStop: Equatable, Hashable {
    let ID: String
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(ID: String, name: String, lat: Double, lon: Double) {
        self.ID = ID
        self.name = name
        self.latitude = lat
        self.longitude = lon
    }
    
    convenience init(ID: String, name: String) {
        self.init(ID: ID, name: name, lat: 0, lon: 0)
    }
    
    static func ==(this: BusStop, that: BusStop) -> Bool {
        return this.ID == that.ID
    }
    
    var hashValue: Int {
        return ID.hashValue
    }
}
