//
//  CTAConnector.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/24/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation
import SwiftyJSON

class CTAConnector {
    private static let instance = CTAConnector()
    
    static let apiRoot = "http://www.ctabustracker.com/bustime/api/v2/"
    static var keySuffix: String { return instance.keySuffix }
    
    private let keySuffix: String
    
    private init() {
        keySuffix = "?format=json&key=" + KeyRing.APIKey
    }
    
    static func dataTask(forCall call: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: apiRoot + call + keySuffix) else {
            return nil
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        return session.dataTask(with: request, completionHandler: completionHandler)
    }
    
}
