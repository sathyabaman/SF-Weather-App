//
//  WeatherModelTest.swift
//  SF WeatherTests
//
//  Created by viewQwest on 06/05/2018.
//  Copyright © 2018 sathyabaman. All rights reserved.
//

import XCTest
@testable import SF_Weather

class WeatherModelTest: XCTestCase {
    
   func testWeatherModelFields(){
        let weather = WeatherModel(id: 20, cityName: "Singapore", condition: "thunderstorms", humidity: 20.6, maxTemperature: 53.6, minTemperature: 30)
        XCTAssertEqual(weather.id, 20)
        XCTAssertEqual(weather.cityName, "Singapore")
        XCTAssertEqual(weather.condition, "thunderstorms")
        XCTAssertEqual(weather.humidity, 20.6)
        XCTAssertEqual(weather.maxTemperature, 53.6)
        XCTAssertEqual(weather.minTemperature, 30)
    }
   
}
