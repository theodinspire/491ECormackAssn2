//
//  RouteTableViewControllerTest.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import XCTest
@testable import _91ECormackAssn2

class RouteTableViewControllerTest: XCTestCase {
    var sut: RouteTableViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RouteTableViewController") as! RouteTableViewController
        sut.loadData()
        
        sleep(1)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadData_DataNowAvailable() {
        XCTAssertTrue(sut.dataLoaded)
    }
    
    func testLoadData_RoutesHaveItems() {
        XCTAssertGreaterThan(sut.routes.count, 0)
    }
    
    func testSeque_RoutePassedToDirectionViewController() {
        //      Setup
        let indexOfRoute = 0
        
        let pressedCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: indexOfRoute, section: 0))
        let destination = DirectionViewController()
        let segue = UIStoryboardSegue(identifier: "RouteStopSegue", source: sut, destination: destination)
        
        sut.prepare(for: segue, sender: pressedCell)
        
        XCTAssertNotNil(destination.route)
        XCTAssertEqual(sut.routes[indexOfRoute], destination.route!)
    }
}
