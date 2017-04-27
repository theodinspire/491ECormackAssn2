//
//  RouteTest.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/26/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import XCTest
@testable import _91ECormackAssn2

class RouteTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit_doesInit() {
        let name = "Clark"
        let number = "22"
        let colorCode = "#cc3300"
        
        let sut = Route(name: name, number: number, colorCode: colorCode)
        
        XCTAssertEqual(name, sut.name)
        XCTAssertEqual(number, sut.number)
        XCTAssertEqual(UIColor.fromHex(string: colorCode), sut.color)
    }
    
}
