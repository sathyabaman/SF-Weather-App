//
//  AddNewData.swift
//  SF Weather
//
//  Created by viewQwest on 05/05/2018.
//  Copyright © 2018 sathyabaman. All rights reserved.
//

import UIKit
import CoreData

class AddNewData: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var CityName: UITextField!
    @IBOutlet weak var minTemp: UITextField!
    @IBOutlet weak var maxTemp: UITextField!
    @IBOutlet weak var weatherCondition: UITextField!
    @IBOutlet weak var humidity: UITextField!
    
    var myPickerView : UIPickerView!
    var pickerData = ["cloudy" , "rain" , "snow" , "sunny", "thunderstorms"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add New Cities"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
      
        //resign first responder
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        weatherCondition.delegate = self as? UITextFieldDelegate
        weatherCondition.addTarget(self, action: #selector(openPicker(_:)),for: .editingDidBegin)
    }

    
    @objc func openPicker(_ textField: UITextField) {
        pickUp(weatherCondition)
    }

    func pickUp(_ textField : UITextField){
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor(red: 34/255, green: 87/255, blue: 126/255, alpha: 1)
        textField.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddNewData.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AddNewData.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.weatherCondition.text = pickerData[row]
    }
 
    @objc func doneClick() {
        weatherCondition.resignFirstResponder()
    }
    @objc func cancelClick() {
        weatherCondition.resignFirstResponder()
    }
    
    
    @IBAction func GoBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigation") as! UINavigationController
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "DashBoard")], animated: false)
        self.present(navigationController, animated:true, completion: nil)
    }
    
    
    
    @IBAction func SaveNewData(_ sender: Any) {
        if validateInputs() {
            var newWeather = WeatherModel()
            newWeather.id = CommanFunction().countNumberOfRecords() + 1
            newWeather.cityName = CityName.text!
            newWeather.condition = weatherCondition.text!
            newWeather.minTemperature = (minTemp.text?.floatValue)!
            newWeather.maxTemperature = (maxTemp.text?.floatValue)!
            newWeather.humidity = (humidity.text?.floatValue)!
            saveSampleDataItem(data: newWeather)
        }
    }
    
    func validateInputs() -> Bool {
        var returnData: Bool = true
        
        let CityNameRange = CityName.text?.rangeOfCharacter(from: .decimalDigits)
        let hasNumbers = (CityNameRange != nil)
        
        if (CityName.text?.count)! < 2 || hasNumbers {
            returnData = false
            showAlert(titl: cityNameTitle, msg: cityNameDesc)
        } else if (weatherCondition.text?.count)! < 1{
            returnData = false
             showAlert(titl: weatherConditionTitle, msg: weatherConditionDesc)
        } else if minTemp.text?.count == 0 || minTemp.text == ""{
            returnData = false
            showAlert(titl: minTemperatureTitle, msg: minTemperatureDesc)
        } else if maxTemp.text?.count == 0 || maxTemp.text == "" {
            returnData = false
            showAlert(titl: maxTemperatureTitle, msg: maxTemperatureDesc)
        }else if humidity.text?.count == 0 || humidity.text == ""{
            returnData = false
            showAlert(titl: humidityTitle, msg: humidityDesc)
        } else if Double((minTemp.text?.floatValue)!) > Double((maxTemp.text?.floatValue)!) {
            returnData = false
            showAlert(titl: minmaxValueTitle, msg: minmaxValueDesc)
        }
        return returnData
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
            GoBack("Back To Home")
        } catch{
            print("There was an error in saving data")
        }
    }
    
    
    func showAlert(titl: String, msg: String){
        let alert = UIAlertController(title: titl, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


