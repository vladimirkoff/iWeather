//
//  CityWeatherViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit

class CityWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var backGround: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var generalTemp: UILabel!
    @IBOutlet weak var maxAndMin: UILabel!
    @IBOutlet weak var mainDescription: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var test: [WeatherModelClass]?
    
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(WeatherArray.weatherArray)
        tableView.delegate = self
        tableView.dataSource = self
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        cityName.text! = String(WeatherParametersForCurrent.cityName)
        generalTemp.text! = String(WeatherParametersForCurrent.temp)
        mainDescription.text! = String(WeatherParametersForCurrent.description)
        maxAndMin.text! = String(WeatherParametersForCurrent.max)
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherCustomCell")
    }
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        WeatherArray.updateWeatherArray()
        performSegue(withIdentifier: Identifiers.goBackFromWeather, sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCustomCell", for: indexPath) as! WeatherTableViewCell
        cell.tempLabel.text = String(WeatherArray.weatherArray[indexPath.row].temp)
        cell.dayLabel.text = DaysArray.daysArray[indexPath.row]
        print(WeatherArray.weatherArray[indexPath.row].icon)
        cell.weatherImage = UIImageView(image: UIImage(named: WeatherArray.weatherArray[indexPath.row].icon))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherArray.weatherArray.count
    }
}
