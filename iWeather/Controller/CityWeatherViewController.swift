//
//  CityWeatherViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit

class CityWeatherViewController: UIViewController {
    
    @IBOutlet var tableViewBackCol: UITableView!
    @IBOutlet var backGround: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var generalTemp: UILabel!
    @IBOutlet weak var maxAndMin: UILabel!
    @IBOutlet weak var mainDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(WeatherArray.weatherArray)
        tableViewBackCol.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
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
}

//MARK: - TableView methods

extension CityWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCustomCell", for: indexPath) as! WeatherTableViewCell
        cell.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        if indexPath.row == 5 {
            cell.dayLabel.text = String(WeatherParametersForCurrent.humidity)
            cell.tempLabel.text = ""
        } else if indexPath.row == 6 {
            cell.dayLabel.text = String(WeatherParametersForCurrent.visibility)
            cell.tempLabel.text = ""
        } else if indexPath.row == 7 {
            cell.dayLabel.text = String(WeatherParametersForCurrent.pressure)
            cell.tempLabel.text = ""
        }
        
        
        else {
            cell.tempLabel.text = String(WeatherArray.weatherArray[indexPath.row].temp)
            cell.dayLabel.text = DaysArray.daysArray[Tracker.count - 1]
            Tracker.count += 1
            if Tracker.count == 8 {
                Tracker.count = WeatherArray.weatherArray[0].day
            }
            cell.weatherImage.image = UIImage(systemName: WeatherArray.weatherArray[indexPath.row].icon)
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherArray.weatherArray.count + 3
    }
}
