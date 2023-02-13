//
//  CityWeatherViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit

class CityWeatherViewController: UIViewController {
    
    @IBOutlet var backGround: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var generalTemp: UILabel!
    @IBOutlet weak var maxAndMin: UILabel!
    @IBOutlet weak var mainDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        cityName.text! = String(WeatherParameters.cityName)
        generalTemp.text! = String(WeatherParameters.temp)
        mainDescription.text! = String(WeatherParameters.description)
        maxAndMin.text! = String(WeatherParameters.max)
    }
    
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Identifiers.goBackFromWeather, sender: self)
    }
}
