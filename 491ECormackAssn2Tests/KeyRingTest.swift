//
//  KeyRingTest.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/24/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import XCTest
@testable import _91ECormackAssn2

class KeyRingTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testKeyRing_ConfirmKeyLoads() {
        XCTAssertEqual(KeyRing.APIKey.characters.count, 25)
    }
}
