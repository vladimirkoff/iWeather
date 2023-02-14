//
//  WeatherTableViewCell.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 14.02.2023.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
//        weatherImage.image = UIImage(named: "cloud.fill")
    }

    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
}
