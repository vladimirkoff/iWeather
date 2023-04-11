//
//  WeatherTableViewCell.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 14.02.2023.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    //MARK: - Properties
    
    @IBOutlet var backGround: UIView!
    @IBOutlet var otherWeatherParametersDescription: UILabel!
    @IBOutlet var otherWeatherParametersIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
    }
    
}
