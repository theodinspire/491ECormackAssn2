//
//  UIColorTest.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/26/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import XCTest
@testable import _91ECormackAssn2

class UIColorTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUIColorFromHexString_FF0000isRed() {
        let sut = UIColor.fromHex(string: "#FF0000")
        
        XCTAssertEqual(sut, UIColor.red)
    }
    
    func testUIColorFromHexString_00FF00isGreen() {
        let sut = UIColor.fromHex(string: "#00FF00")
        
        XCTAssertEqual(sut, UIColor.green)
    }
    
    func testUIColorFromHexString_0000ffisBlue() {
        let sut = UIColor.fromHex(string: "x0000ff")
        
        XCTAssertEqual(sut, UIColor.blue)
    }
    
    func testUIColorFromHexString_StringisNil() {
        let sut = UIColor.fromHex(string: "string")
        
        XCTAssertNil(sut)
    }
    
    func testUIColorFromHexString_LongHexIsNil() {
        let sut = UIColor.fromHex(string: "0x0123456789abcdef")
        
        XCTAssertNil(sut)
    }
}
