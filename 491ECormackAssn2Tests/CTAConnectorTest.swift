//
//  CTAConnectorTest.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/25/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import _91ECormackAssn2

class CTAConnectorTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetDataTask_ShouldRespond() {
        let responseExpectation = expectation(description: "Response is successful")
        
        let dataTask = CTAConnector.dataTask(forCall: "gettime") { _, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            let code = (response as? HTTPURLResponse)?.statusCode ?? 400
            
            if code == 200 { responseExpectation.fulfill() }
        }
        
        dataTask?.resume()
        
        wait(for: [responseExpectation], timeout: 2)
    }    
}
