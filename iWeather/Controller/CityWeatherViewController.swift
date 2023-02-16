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

    @IBOutlet var backButton: UIButton!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var maxLabel: UILabel!
    @IBOutlet weak var mainDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setTitle("", for: .normal)
        
        tableViewBackCol.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        cityName.text! = String(WeatherParametersForCurrent.cityName.replacingOccurrences(of: "%20", with: "-"))
        generalTemp.text! = "\(Int(WeatherParametersForCurrent.temp))°"
        mainDescription.text! = String(WeatherParametersForCurrent.description)
        maxLabel.text! = "H:\(WeatherParametersForCurrent.max)"
        minLabel.text! = "L:\(WeatherParametersForCurrent.min)"
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: Identifiers.weatherCell)
    }
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        WeatherArray.updateWeatherArray()
        performSegue(withIdentifier: Identifiers.goBackFromWeather, sender: self)
    }
}

//MARK: - TableView methods

extension CityWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.weatherCell, for: indexPath) as! WeatherTableViewCell
        print(indexPath.row)
        cell.dayLabel.textColor = .white
        cell.tempLabel.textColor = .white
        cell.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        if indexPath.row == 5 {
            cell.dayLabel.text = ""
            cell.otherWeatherParametersDescription.textColor = .white
            cell.otherWeatherParametersDescription.text = "Humidity"
            cell.otherWeatherParametersIcon.image = UIImage(systemName: "humidity.fill")
            cell.tempLabel.text = String(WeatherParametersForCurrent.humidity)
        } else if indexPath.row == 6 {
            cell.dayLabel.text = ""
            cell.otherWeatherParametersDescription.textColor = .white
            cell.otherWeatherParametersDescription.text = "Visibility"
            cell.otherWeatherParametersIcon.image = UIImage(systemName: "eye.fill")
            cell.tempLabel.text = String(WeatherParametersForCurrent.visibility)
        } else if indexPath.row == 7 {
            cell.dayLabel.text = ""
            cell.otherWeatherParametersDescription.textColor = .white
            cell.otherWeatherParametersDescription.text = "Feels like"
            cell.otherWeatherParametersIcon.image = UIImage(systemName: "thermometer.low")
            cell.tempLabel.text = String(WeatherParametersForCurrent.feels_like)
        } else if indexPath.row == 8 {
            cell.dayLabel.text = ""
            cell.otherWeatherParametersDescription.textColor = .white
            cell.otherWeatherParametersDescription.text = "Pressure"
            cell.otherWeatherParametersIcon.image = UIImage(systemName: "speedometer")
            cell.tempLabel.text = String(WeatherParametersForCurrent.pressure)
        }
        else {
            cell.otherWeatherParametersDescription.text = ""
            cell.dayLabel.text = "Day"
            DispatchQueue.main.async {
                
                cell.tempLabel.text = "\(WeatherArray.weatherArray[indexPath.row].temp)°"
                cell.weatherImage.image = UIImage(systemName: WeatherArray.weatherArray[indexPath.row].icon)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherArray.weatherArray.count + 4
    }
}
