//
//  StopManager.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 5/18/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import SwiftyJSON
import Dispatch

class StopManager {
    static let instance = StopManager()
    
    var routeStops = [String: BusStop]()
    var stops: Set<BusStop> = []
    
    private init() {
        
    }
    
}
