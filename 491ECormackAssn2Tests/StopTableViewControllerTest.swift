//
//  StopTableViewControllerTest.swift
//  491ECormackAssn2
//
//  Created by Eric Cormack on 4/28/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import _91ECormackAssn2

class StopTableViewControllerTest: XCTestCase {
    var sut: StopTableViewController!
    
    let indexOfCell = 0
    var cellToTest: StopTableViewCell!
    
    let route = Route(name: "Clark", number: "22")
    // 22 is known to be North-South
    let direction = Direction.Northbound
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StopTableViewController") as! StopTableViewController
        sut.route = route
        sut.direction = direction
        sut.loadView()
        sleep(1)
        cellToTest = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: indexOfCell, section: 0)) as! StopTableViewCell
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNumberOfSections_IsOne() {
        XCTAssertEqual(sut.numberOfSections(in: sut.tableView), 1)
    }
    
    func testStopsCount_IsGreaterThanZero() {
        XCTAssertGreaterThan(sut.stops.count, 0)
    }
    
    func testDataLoad_DataLoadedIsTrue() {
        XCTAssert(sut.dataLoaded)
    }
    
    func testStopsCells_HasStopOfIndex() {
        XCTAssertEqual(sut.stops[indexOfCell], cellToTest.stop)
    }
    
//    func testStopCells_LabelOfCellMatchesStopName() {
//        XCTAssertEqual(cellToTest.stop.name, cellToTest.label.text)
//    }
    
    func testSegue_DataPassedToTimeViewController() {
        let pressedCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: indexOfCell, section: 0))
        let destination = TimeViewController()
        let segue = UIStoryboardSegue(identifier: "StopTimeSegue", source: sut, destination: destination)
        
        sut.prepare(for: segue, sender: pressedCell)
        
        XCTAssertNotNil(destination.stop)
    }
}
