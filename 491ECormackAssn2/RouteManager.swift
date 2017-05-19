//
//  RouteManager.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 5/18/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import SwiftyJSON
import Dispatch

class RouteManager {
    static let instance = RouteManager()
    
    var routes = [Route]()
    var dataLoaded = false {
        didSet {
            while dataLoaded, let (task, queue) = taskStack.popLast() {
                queue.async(execute: task)
            }
        }
    }
    
    private var taskStack = [(task: () -> Void, queue: DispatchQueue)]()
    
    private init() {
        CTAConnector.makeRequest(forCall: "getroutes") { data in
            let json = JSON(data: data)
            
            guard let rts = json["bustime-response"]["routes"].array else {
                print("Routes data not correctly shaped as array")
                print(json)
                return
            }
            
            for rt in rts {
                let colorCode = rt["rtclr"].string // Can be option
                if let number = rt["rt"].string, let name = rt["rtnm"].string { // Must have value
                    self.routes.append(Route(name: name, number: number, colorCode: colorCode))
                }
            }
            
            self.dataLoaded = true
        }
    }
    
    func performWhenDataLoaded(in queue: DispatchQueue, task: @escaping () -> Void) {
        if dataLoaded { queue.async(execute: task) }
        else { taskStack.append((task, queue)) }
    }
}
