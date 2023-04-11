//
//  CityWeatherViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit

class CityWeatherViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet var tableViewBackCol: UITableView!
    @IBOutlet var backGround: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var generalTemp: UILabel!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var maxLabel: UILabel!
    @IBOutlet weak var mainDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var weatherArray2: [WeatherDayModel]? {
        didSet { tableView.reloadData() }
    }
    
    var params: WeatherParametersForCurrent?
    
    let weatherManager = WeatherManager()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        
        if Tracker.isForCurrent {
            fetchWeatherForFiveDays(lat: LonAndLat.lat , lon: LonAndLat.lon)
        } else {
            fetchWeatherForFiveDays(city: params!.cityName)
        }
    }
    
    //MARK: - API
    
    func fetchWeatherForFiveDays(city: String? = nil, lat: Double? = nil, lon: Double? = nil) {
        if let city = city {
            WeatherManagerForFive.fetchWeatherForecast(city: city) { weatherArray in
                self.weatherArray2 = weatherArray
            }
        } else {
            WeatherManagerForFive.fetchWeatherForecast(lon: lon, lat: lat) { weatherArray in
                self.weatherArray2 = weatherArray
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        guard let params = self.params else { return }
        
        tableViewBackCol.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        
        cityName.text = params.cityName
        generalTemp.text! = "\(Int(params.temp))°"
        mainDescription.text! = String(params.description)
        maxLabel.text! = "H:\(params.max)"
        minLabel.text! = "L:\(params.min)"
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: Identifiers.weatherCell)
    }
    
    
    //MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Identifiers.goBackFromWeather, sender: self)
    }
    
}

//MARK: - UITableViewDelegate & DataSource

extension CityWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.weatherCell, for: indexPath) as! WeatherTableViewCell
        cell.dayLabel.textColor = .white
        cell.tempLabel.textColor = .white
        
        if let weatherArray = weatherArray2 {
            switch indexPath.row {
            case 0:
                cell.dayLabel.text = weatherArray[indexPath.row].day
            case 1:
                cell.dayLabel.text = weatherArray[indexPath.row].day
            case 2:
                cell.dayLabel.text = weatherArray[indexPath.row].day
            case 3:
                cell.dayLabel.text = weatherArray[indexPath.row].day
            case 4:
                cell.dayLabel.text = weatherArray[indexPath.row].day
            default:
                cell.dayLabel.text = "Mon"         }
            
            if let params = params {
                if indexPath.row == 5 {
                    createCellForAdditionalParameters(cell: cell, imageName: "humidity.fill", description: "Humidity")
                    cell.tempLabel.text = "\(params.humidity)%"
                } else if indexPath.row == 6 {
                    createCellForAdditionalParameters(cell: cell, imageName: "eye.fill", description: "Visibility")
                    cell.tempLabel.text = "\(params.visibility)m"
                } else if indexPath.row == 7 {
                    createCellForAdditionalParameters(cell: cell, imageName: "thermometer.low", description: "Feels like")
                    cell.tempLabel.text = "\(params.feels_like)°"
                } else if indexPath.row == 8 {
                    createCellForAdditionalParameters(cell: cell, imageName: "wind", description: "Wind speed")
                    cell.tempLabel.text = "\(params.speed)km/h"
                } else {
                    cell.otherWeatherParametersDescription.text = ""
                    cell.tempLabel.text = "\(weatherArray[indexPath.row].temp)°"
                    cell.weatherImage.image = UIImage(systemName: weatherArray[indexPath.row].icon)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func createCellForAdditionalParameters(cell: WeatherTableViewCell, imageName: String, description: String) {
        cell.dayLabel.text = ""
        cell.otherWeatherParametersDescription.textColor = .white
        cell.otherWeatherParametersDescription.text = description
        cell.otherWeatherParametersIcon.image = UIImage(systemName: imageName)
    }
}
