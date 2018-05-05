//
//  AddNewData.swift
//  SF Weather
//
//  Created by viewQwest on 05/05/2018.
//  Copyright © 2018 sathyabaman. All rights reserved.
//

import UIKit

class AddNewData: UIViewController {
    @IBOutlet weak var CityName: UITextField!
    @IBOutlet weak var minTemp: UITextField!
    @IBOutlet weak var maxTemp: UITextField!
    @IBOutlet weak var weatherCondition: UITextField!
    @IBOutlet weak var humidity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add New Cities"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
      
        //resign first responder
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func GoBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigation") as! UINavigationController
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "DashBoard")], animated: false)
        self.present(navigationController, animated:true, completion: nil)
    }
    
    
    @IBAction func SaveNewData(_ sender: Any) {
        validateInputs()
    }
    
    func validateInputs() -> Bool {
        var returnData: Bool = true
        
        let CityNameRange = CityName.text?.rangeOfCharacter(from: .decimalDigits)
        let hasNumbers = (CityNameRange != nil)
        
       
//        var number = minTemp.text?.isNumber
//        print(number)
        
        
    
        
        if (CityName.text?.count)! < 2 || hasNumbers {
            returnData = false
            showAlert(titl: cityNameTitle, msg: cityNameDesc)
        }
        
        
        return returnData
    }
    
    
    func showAlert(titl: String, msg: String){
        let alert = UIAlertController(title: titl, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


