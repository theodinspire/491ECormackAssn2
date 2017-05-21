//
//  Prediction.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/29/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

struct Prediction {
    let destination: String
    let routeNum: String
    let type: PredictionType?
    let direction: Direction
    let waittime: Int
    let stopName: String
}

enum PredictionType: String {
    case Arrival, Departure
    
    init?(forKey key: String) {
        switch key {
        case "A":
            self = .Arrival
        case "D":
            self = .Departure
        default:
            return nil
        }
    }
}
