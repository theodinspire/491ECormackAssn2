//
//  Route.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/26/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class Route: Equatable {
    let name: String
    let number: String
    lazy var color: UIColor = UIColor.lightGray
    
    init(name: String, number: String, colorCode: String? = nil) {
        self.name = name
        self.number = number
        
        if let code = colorCode, let clr = UIColor.fromHex(string: code) { color = clr }
    }
    
    static func ==(this: Route, that: Route) -> Bool {
        return this.number == that.number
    }
}
