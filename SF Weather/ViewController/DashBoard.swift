//
//  DashBoard.swift
//  SF Weather
//
//  Created by viewQwest on 05/05/2018.
//  Copyright © 2018 sathyabaman. All rights reserved.
//

import UIKit

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


}
