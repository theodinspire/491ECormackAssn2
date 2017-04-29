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
    
    static func dataTask(forCall call: String, withArguments args: [String] = [], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        var arguments = ""
        for arg in args { arguments += "&" + arg }
        
        guard let url = URL(string: apiRoot + call + keySuffix + arguments) else {
            return nil
        }
        
        print(url)
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        return session.dataTask(with: request, completionHandler: completionHandler)
    }
    
    static func makeRequest(forCall call: String, withArguments args: [String] = [], failureTask: @escaping () -> Void = { }, completionHandler: @escaping (Data) -> Void) {
        dataTask(forCall: call, withArguments: args) {optdata, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                failureTask()
                return
            }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                } else {
                    print("Response is not hyper-text transfer protocol")
                }
                
                print("A correct response would have HTTP Status code of 200")
                failureTask()
                return
            }
            
            guard let data = optdata else {
                print("Data malformed")
                failureTask()
                return
            }
            
            completionHandler(data)
        }?.resume()
    }
    
}
