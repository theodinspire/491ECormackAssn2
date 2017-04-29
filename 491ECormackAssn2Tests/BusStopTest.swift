//
//  BusStopTest.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/28/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import _91ECormackAssn2

class BusStopTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit_IsSet() {
        let stopID = "1819"
        let stopName = "3930 N Clark"
        let stopLat = 41.953534129565
        let stopLon = -87.630865930988
        
        let sut = BusStop(ID: stopID, name: stopName, lat: stopLat, lon: stopLon)
        
        XCTAssertEqual(sut.ID, stopID)
        XCTAssertEqual(sut.name, stopName)
        XCTAssertEqual(sut.latitude, stopLat)
        XCTAssertEqual(sut.longitude, stopLon)
    }
    
}
