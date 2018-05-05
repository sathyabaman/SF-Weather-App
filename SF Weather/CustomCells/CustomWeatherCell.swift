//
//  CustomWeatherCell.swift
//  SF Weather
//
//  Created by viewQwest on 05/05/2018.
//  Copyright © 2018 sathyabaman. All rights reserved.
//

import UIKit

class CustomWeatherCell: UITableViewCell {

    @IBOutlet weak var CityImage: UIImageView!
    @IBOutlet weak var CityName: UILabel!
    @IBOutlet weak var CityMinMaxTemp: UILabel!
    @IBOutlet weak var CityHumidity: UILabel!
    @IBOutlet weak var CityCondition: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
