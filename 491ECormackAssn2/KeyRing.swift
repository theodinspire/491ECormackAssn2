//
//  KeyRing.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/24/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class KeyRing {
    static private let instance = KeyRing()
    
    static var APIKey: String { return instance.key ?? "" }
    
    private let key: String?
    
    private init() {
        var keyDictionary: [String : Any]?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keyDictionary = NSDictionary(contentsOfFile: path) as? [String : Any]
        }
        
        if let keyDictionary = keyDictionary as? [String : String], let key = keyDictionary["APIKey"] {
            self.key = key
        } else { self.key = nil }
    }
}
