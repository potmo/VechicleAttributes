//
//  VehicleAttributesTests.swift
//  VehicleAttributesTests
//
//  Created by Tom Dowding on 15/08/2017.
//
//

import XCTest
@testable import VehicleAttributes

class VehicleAttributesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: - Car Class Tests

    // Confirm that the Car initializer returns a Car object when passed valid parameters.
    func testCarInitializatonSucceeds() {
        
        // Valid sample vin
        let car = Car.init(vin: "tmbga61z852094863")
        XCTAssertNotNil(car)
    }
    
    // Confirm that the Car initialier returns nil when passed an empty vin.
    func testCarInitializatonFails() {
        
        // Empty vin
        let emptyVinCar = Car.init(vin: "")
        XCTAssertNil(emptyVinCar)
    }
}
