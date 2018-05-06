//
//  CommanFunctionTests.swift
//  SF WeatherTests
//
//  Created by viewQwest on 06/05/2018.
//  Copyright © 2018 sathyabaman. All rights reserved.
//

import XCTest
@testable import SF_Weather

class CommanFunctionTests: XCTestCase {
    

    func testWeatherImage(){
        let Condition: String  = "thunderstorms"
        let result: String = "thunderstorms"
        XCTAssertEqual(CommanFunction().weatherImage(ImageName: Condition), result)
    }
    
    func testCountNumberRecords() {
        XCTAssertNotNil(CommanFunction().countNumberOfRecords(), "Not Nil")
    }
    
    
    
    
}
