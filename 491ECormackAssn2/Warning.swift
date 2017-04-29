//
//  Warning.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/29/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

struct Warning {
    let name: String
    let detail: String
    let priority: WarningPriority
}

enum WarningPriority: String {
    case High, Medium, Low
}
