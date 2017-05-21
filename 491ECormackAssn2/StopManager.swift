//
//  StopManager.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 5/18/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import SwiftyJSON
import Dispatch
import MapKit

class StopManager {
    static let instance = StopManager()
    
    var stopsToRoutes: [BusStop: [RouteDirection]] = [:]
    var routeToStops = [Route: [Direction: [BusStop]]]() {
        didSet { performAllTasks() }
    }
    
    var taskStack = [(route: Route, heading: Direction?, task: () -> Void, queue: DispatchQueue)]()
    
    private init() { }
    
    func add(route: Route) {
        if routeToStops[route] == nil {
            routeToStops[route] = [Direction: [BusStop]]()
        }
        
        CTAConnector.makeRequest(forCall: "getdirections", withArguments: ["rt=\(route.number)"]) { data in
            let json = JSON(data: data)
            
            var directions = [Direction]()
            
            if let ary = json["bustime-response"]["directions"].array {
                for item in ary {
                    if let str = item["dir"].string, let direction = Direction(rawValue: str) {
                        directions.append(direction)
                    }
                }
            }
            
            for direction in directions {
                //  TODO: Is this even gonna work?
                CTAConnector.makeRequest(forCall: "getstops", withArguments: ["rt=\(route.number)", "dir=\(direction.rawValue)"]) { data in
                    let json = JSON(data: data)
                    
                    guard let stps = json["bustime-response"]["stops"].array else {
                        print("Stops data malformed")
                        print(json["bustime-response"]["stops"].error.debugDescription)
                        print(json)
                        return
                    }
                    
                    var stopList = [BusStop]()
                    
                    for stp in stps {
                        guard let ID = stp["stpid"].string else { break }
                        guard let name = stp["stpnm"].string else { break }
                        let lat = stp["lat"].doubleValue
                        let lon = stp["lon"].doubleValue
                        
                        let stopItem = BusStop(ID: ID, name: name, latitude: lat, longitude: lon)
                        stopList.append(stopItem)
                        
                        var tmp = self.stopsToRoutes[stopItem] ?? []
                        tmp.append(RouteDirection(route: route, direction: direction))
                        self.stopsToRoutes[stopItem] = tmp
                    }
                    
                    self.routeToStops[route]?[direction] = stopList
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
        if let heading = item.heading, let _ = routeToStops[item.route]?[heading] {
            item.queue.async(execute: item.task)
            return true
        } else if item.heading == nil, let _ = routeToStops[item.route]?.first {
            item.queue.async(execute: item.task)
            return true
        } else { return false }
    }
    
    func getStops(near location: CLLocation, within distance: CLLocationDistance) -> [BusStop] {
        return stopsToRoutes.keys.filter { location.distance(from: $0.location) <= distance }
    }
    
    func getRoutesAndDirections(for stops: [BusStop]) -> Set<RouteDirection> {
        var set = Set<RouteDirection>()
        stops.forEach { if let routes = stopsToRoutes[$0] { set.formUnion(routes) } }
        return set
    }
}
