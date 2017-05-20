//
//  DirectionViewControllerTest.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import _91ECormackAssn2

class DirectionViewControllerTest: XCTestCase {
    var sut: DirectionViewController!
    
    let northsouth = Route(name: "Clark", number: "22")
    let eastwest = Route(name: "Addion", number: "152")

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectionViewController") as! DirectionViewController
        sut.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRoute_IsSet() {
        sut.route = northsouth
        sleep(1)
        
        XCTAssertEqual(sut.route?.name, northsouth.name)
    }
    
//    func testPrimaryDirectionSet_IsNorthOrSouthbound() {
//        //  Route 22 is known to be North-South
//        sut.route = northsouth
//        sleep(1)
//        
//        XCTAssert(sut.primaryDirection == .Northbound || sut.primaryDirection == .Southbound)
//    }
//    
//    func testPrimaryDirectionSet_IsEastOrWestbound() {
//        //  Route 152 is known to be East-West
//        sut.route = eastwest
//        sleep(1)
//        
//        XCTAssert(sut.primaryDirection == .Eastbound || sut.primaryDirection == .Westbound)
//    }
    
    func testSeque_RouteAndDirectionPassedToStopTableViewController() {
        let direction = Direction.Northbound
        sut.route = northsouth
        sleep(1)
        
        let destination = StopTableViewController()
        
        let sender = { (dirVC: DirectionViewController) -> UIButton? in
            for subview in dirVC.north.subviews {
                if let button = subview as? UIButton { return button }
                }
            return nil
        }(sut)
        
        XCTAssertNotNil(sender)
        
        let segue = UIStoryboardSegue(identifier: "NorthboundSegue", source: sut, destination: destination)
        
        sut.prepare(for: segue, sender: sender)
        
        XCTAssertEqual(destination.route?.name, sut.route?.name)
        XCTAssertEqual(destination.route?.number, sut.route?.number)
        XCTAssertEqual(destination.direction, direction)
    }
}
