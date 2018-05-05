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
    @IBOutlet weak var buttonOrderBy: UIButton!
    
    var weatherData = [WeatherModel]()
    var CurrentIndexToDelete: Int = 1000
    var NextOrderId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather List"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        //Broadcast Receiver
        NotificationCenter.default.addObserver(self, selector: #selector(dataAdded(_:)), name: NSNotification.Name(rawValue: "SampleData"), object: nil)
        
        
        //Check for Records in db
        CommanFunction().countNumberOfRecords() == 0 ? showAlert(Title: noDataTitle, Desc: noDataDesc) : retrieveWatherData()
        
        // button style
        buttonOrderBy.layer.masksToBounds = true
        buttonOrderBy.layer.cornerRadius = 5
        buttonOrderBy.layer.borderWidth = 1
        buttonOrderBy.layer.borderColor = UIColor.white.cgColor
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomWeatherCell", owner: self, options: nil)?.first as! CustomWeatherCell
        cell.CityName.text = weatherData[indexPath.row].cityName
        cell.CityHumidity.text = String (weatherData[indexPath.row].humidity)
        cell.CityImage.image = UIImage(named: CommanFunction().weatherImage(ImageName: weatherData[indexPath.row].condition))
        cell.CityMinMaxTemp.text = "Temperature : \(String (weatherData[indexPath.row].minTemperature)) ℃  -  \(String (weatherData[indexPath.row].maxTemperature)) ℃"
        cell.CityCondition.text = weatherData[indexPath.row].condition
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            CurrentIndexToDelete = indexPath.row
            showAlert(Title: deleteTitle, Desc: deleteDesc)
        }
    }

    
    //Alert
    func showAlert(Title: String, Desc: String) -> Void {
        let refreshAlert = UIAlertController(title: Title, message: Desc, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Yes, Please!", style: .default, handler: { (action: UIAlertAction!) in
            switch Title {
                case "No Weather Data" :
                    CommanFunction().addSampleData()
                    break
                case "Delete Record":
                    DispatchQueue.main.async {
                        self.deleteData(deleteID: self.weatherData[self.CurrentIndexToDelete].id)
                        self.weatherData.remove(at: self.CurrentIndexToDelete)
                        self.WeatherTable.reloadData()
                    }
                    break
                default :
                    break
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func dataAdded(_ notification: NSNotification) {
        if let topic = notification.userInfo?["Topic"] as? String {
            print(topic)
        }
        if let message = notification.userInfo?["message"] as? String {
            print(message)
            
            self.retrieveWatherData()
            self.WeatherTable.reloadData()
        }
    }
    
    
    @IBAction func buttonOrderList(_ sender: Any) {
        switch NextOrderId {
        case 0:
            weatherData =  weatherData.sorted(by: { $0.minTemperature < $1.minTemperature })
            buttonOrderBy.setTitle("Temperature", for: .normal)
            NextOrderId = 1
            buttonOrderBy.setTitle("Min Temperature", for: .normal)
        case 1:
            weatherData =  weatherData.sorted(by: { $0.maxTemperature < $1.maxTemperature })
            NextOrderId = 2
            buttonOrderBy.setTitle("Max Temperature", for: .normal)
        case 2:
            weatherData =  weatherData.sorted(by: { $0.cityName < $1.cityName })
            NextOrderId = 3
            buttonOrderBy.setTitle("City Name", for: .normal)
        case 3:
            weatherData =  weatherData.sorted(by: { $0.humidity < $1.humidity })
            NextOrderId = 0
            buttonOrderBy.setTitle("Humidity", for: .normal)
        default:
            NextOrderId = 0
            weatherData =  weatherData.sorted(by: { $0.minTemperature < $1.minTemperature })
            buttonOrderBy.setTitle("Temperature", for: .normal)
            break
        }
        
        
           self.WeatherTable.reloadData()
    }
    
    
    
    // Order Data Methods
    
    
    //Core Data Methods
    func retrieveWatherData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherList")
        
        do {
            let results = try context.fetch(fetchRequest)
            let obtainedResults = results as! [NSManagedObject]
            for i in 0 ..< obtainedResults.count{
                let firstResult = obtainedResults[i]
                
                weatherData.append(WeatherModel(id: firstResult.value(forKey: "id") as! Int,
                                                cityName: firstResult.value(forKey: "cityName") as! String,
                                                condition: firstResult.value(forKey: "condition") as! String,
                                                humidity: firstResult.value(forKey: "humidity") as! Float,
                                                maxTemperature: firstResult.value(forKey: "maxTemperature") as! Float,
                                                minTemperature: firstResult.value(forKey: "minTemperature") as! Float))
            }
        } catch {
            print("Error")
        }
    }
    
    func deleteData(deleteID: Int){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<WeatherList>(entityName: "WeatherList")
        let predicate = NSPredicate(format: "id == \(deleteID)")
        fetchRequest.predicate = predicate
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [WeatherList]
        
            for object in resultData {
                context.delete(object)
            }
        
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
    }

}
