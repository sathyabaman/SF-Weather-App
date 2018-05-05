//
//  CommanFunction.swift
//  SF Weather
//
//  Created by viewQwest on 05/05/2018.
//  Copyright © 2018 sathyabaman. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CommanFunction: NSObject {
    
    
    //Count Number of Records in Coredatas WeatherList table
    func countNumberOfRecords() ->Int{
        var totalRecord: Int = 0
        
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherList")
        
            do {
                let results = try context.fetch(fetchRequest)
                let obtainedResults = results as! [NSManagedObject]
                totalRecord = obtainedResults.count
            } catch {
                print("Error")
            }
        
        return totalRecord
    }
    
    
    //Add sample Data
    func addSampleData(){
        var WeatherData = [WeatherModel]()
        WeatherData.append(WeatherModel(id: 1, cityName: "Kilinochchi, Sri Lanka", condition: "cloudy", humidity: 22.3, maxTemperature: 38.6, minTemperature: 13.60))
        WeatherData.append(WeatherModel(id: 2, cityName: "Sydney, NSW", condition: "rain", humidity: 25.3, maxTemperature: 40.6, minTemperature: 8.20))
        WeatherData.append(WeatherModel(id: 3, cityName: "Kuala Lumpur, Malaysia", condition: "snow", humidity: 68.3, maxTemperature: 25, minTemperature: 115))
        WeatherData.append(WeatherModel(id: 4, cityName: "Manchester, UK", condition: "sunny", humidity: 80, maxTemperature: 38.6, minTemperature: 26.60))
        WeatherData.append(WeatherModel(id: 5, cityName: "Colombo, Sri Lanka", condition: "thunderstorms", humidity: 22.3, maxTemperature: 38.6, minTemperature: 20.60))
        
        for item in WeatherData {
            DispatchQueue.main.async {
                self.saveSampleDataItem (data: item)
            }
        }
    }
    
    func saveSampleDataItem(data: WeatherModel){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "WeatherList",  in: context)
        let newWeather = NSManagedObject(entity: entity!, insertInto: context)
        newWeather.setValue(data.id, forKey: "id")
        newWeather.setValue(data.cityName, forKey: "cityName")
        newWeather.setValue(data.condition, forKey: "condition")
        newWeather.setValue(data.humidity, forKey: "humidity")
        newWeather.setValue(data.maxTemperature, forKey: "maxTemperature")
        newWeather.setValue(data.minTemperature, forKey: "minTemperature")
        
        do {
            try context.save()
            if self.countNumberOfRecords() == 5 {
                DispatchQueue.main.async() {
                    let data = [ "Topic" : "SampleData" , "message": "Sample Data added" ] as [String : Any]
                    let notificationName = Notification.Name("SampleData")
                    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: data)
                }
            }
        } catch{
            print("There was an error in saving data")
        }
    }
    
    
    //func Get Weather Image Name
    func weatherImage(ImageName: String) -> String {
        var returnString = ""
        switch ImageName.lowercased() {
        case "cloudy":
            returnString = "cloudy"
        case "rain":
            returnString = "rain"
        case "snow":
            returnString = "snow"
        case "sunny":
            returnString = "sunny"
        case "thunderstorms":
            returnString = "thunderstorms"
        default:
            returnString = ""
            break
        }
        return returnString
    }
    
}
