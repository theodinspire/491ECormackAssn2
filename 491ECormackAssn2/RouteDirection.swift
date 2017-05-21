//
//  RouteDirection.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 5/20/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

struct RouteDirection: Hashable {
    var route: Route
    var direction: Direction
    
    var hashValue: Int {
        return route.hashValue + direction.hashValue
    }
    
    static func ==(_ this: RouteDirection, _ that: RouteDirection) -> Bool {
        return this.route == that.route && this.direction == that.direction
    }
}
