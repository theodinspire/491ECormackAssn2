//
//  Direction.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

enum Direction: String {
    case Northbound, Eastbound, Southbound, Westbound
    
    var opposite: Direction {
        switch self {
        case .Northbound:
            return .Southbound
        case .Eastbound:
            return .Westbound
        case .Southbound:
            return .Northbound
        case.Westbound:
            return .Eastbound
        }
    }
}
