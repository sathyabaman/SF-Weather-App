//
//  DashBoard.swift
//  SF Weather
//
//  Created by viewQwest on 05/05/2018.
//  Copyright © 2018 sathyabaman. All rights reserved.
//

import UIKit
import CoreData

class DashBoard: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var WeatherTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather List"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomWeatherCell", owner: self, options: nil)?.first as! CustomWeatherCell
        cell.selectionStyle = .none
        return cell
    }

    
    @IBAction func buttonOrderList(_ sender: Any) {
      //  saveItem()
        
        retrieveWatherData()
    }
    
    func saveItem(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //**Note:** Here we are providing the entityName **`Entity`** that we have added in the model
        let entity = NSEntityDescription.entity(forEntityName: "WeatherList",  in: context)

       
                let newWeather = NSManagedObject(entity: entity!, insertInto: context)
                newWeather.setValue(1, forKey: "id")
                newWeather.setValue("Kilinochchi", forKey: "cityName")
                newWeather.setValue("SUNNY", forKey: "condition")
                newWeather.setValue(23.2, forKey: "humidity")
                newWeather.setValue(60, forKey: "maxTemperature")
                newWeather.setValue(10, forKey: "minTemperature")
        
                do {
                    try context.save()
                } catch{
                    print("There was an error in saving data")
                }
    }
    
    func retrieveWatherData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherList")
        
        do {
            let results = try context.fetch(fetchRequest)
            let obtainedResults = results as! [NSManagedObject]
            for i in 0 ..< obtainedResults.count{
                let firstResult = obtainedResults[i]
                let myValue = firstResult.value(forKey: "humidity")
                print("Humidity: \(myValue)")
            }
        } catch {
            print("Error")
        }
    }

}
