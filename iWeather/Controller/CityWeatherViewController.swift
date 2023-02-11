//
//  CityWeatherViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit

class CityWeatherViewController: UIViewController {
    
    
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var visibility: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speed.text! = String(WeatherParameters.speed) 
        humidity.text! = String(WeatherParameters.humidity)
    }
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Identifiers.goBackFromWeather, sender: self)
    }
}
