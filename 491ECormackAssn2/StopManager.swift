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
    
    var stops: Set<BusStop> = []
    var routeStops = [Route: [Direction: [BusStop]]]() {
        didSet { performAllTasks() }
    }
    
    var taskStack = [(route: Route, heading: Direction?, task: () -> Void, queue: DispatchQueue)]()
    
    private init() { }
    
    func add(route: Route) {
        if routeStops[route] == nil {
            routeStops[route] = [Direction: [BusStop]]()
        }
        
        CTAConnector.makeRequest(forCall: "getdirections", withArguments: ["rt=\(route.number)"]) { data in
            let json = JSON(data: data)
            
            if let str = json["bustime-response"]["directions"].array?[0]["dir"].string, let direction = Direction(rawValue: str) {
                
                for dir in [direction, direction.opposite] {
                    //  TODO: Is this even gonna work?
                    CTAConnector.makeRequest(forCall: "getstops", withArguments: ["rt=\(route.number)", "dir=\(dir.rawValue)"]) { data in
                        let json = JSON(data: data)
                        
                        guard let stps = json["bustime-response"]["stops"].array else {
                            print("Stops data malformed")
                            print(json["bustime-response"]["stops"].error.debugDescription)
                            print(json)
                            return
                        }
                        
                        var stops = [BusStop]()
                        
                        for stp in stps {
                            guard let ID = stp["stpid"].string else { break }
                            guard let name = stp["stpnm"].string else { break }
                            let lat = stp["lat"].doubleValue
                            let lon = stp["lon"].doubleValue
                            
                            stops.append(BusStop(ID: ID, name: name, lat: lat, lon: lon))
                        }
                        
                        self.routeStops[route]?[dir] = stops
                    }
                }
            }
        }
    }
    
    func performTaskWhenLoaded(for route: Route, going heading: Direction?, on queue: DispatchQueue, task: @escaping () -> Void) {
        let item = (route, heading, task, queue)
        if !performTask(of: item) {
            taskStack.append(item)
        }
    }
    
    private func performAllTasks() {
        var notPerformed = [(route: Route, heading: Direction?, task: () -> Void, queue: DispatchQueue)]()
        
        for item in taskStack {
            if !performTask(of: item) { notPerformed.append(item) }
        }
        
        taskStack = notPerformed
    }
    
    private func performTask(of item: (route: Route, heading: Direction?, task: () -> Void, queue: DispatchQueue)) -> Bool {
        if let heading = item.heading, let _ = routeStops[item.route]?[heading] {
            item.queue.async(execute: item.task)
            return true
        } else if item.heading == nil, let _ = routeStops[item.route]?.first {
            item.queue.async(execute: item.task)
            return true
        } else { return false }
    }
}
