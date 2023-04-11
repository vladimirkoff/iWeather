//
//  LoadingViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit
import CoreData
import CoreLocation

class LoadingViewController: UIViewController {
    
    @IBOutlet var backGround: UIView!
    
    
    var cityName: String?  {
        didSet {
            WeatherManagerForFive.fetchWeatherForForcast(city: cityName!)
            WeatherManager.fetchWeather(city: cityName!)
        }
    } // New%20York
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tracker: Bool?
    
    let locationManager = CLLocationManager()
    
    var params: WeatherParametersForCurrent?
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let lat = LonAndLat.lat, let lon = LonAndLat.lon {
            WeatherManager.fetchWeatherForCurrentLocation(lon: lon, lat: lat)
            WeatherManagerForFive.fetchWeatherForForcast(lon: lon, lat: lat)
        } else if Tracker.isForCurrent {
            locationManager.requestLocation()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        WeatherParametersForCurrent.delegate = self
        locationManager.delegate = self
        WeatherManager.delegate = self
        
        DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    
    func configureUI() {
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
    }
}

//MARK: - CoreData methods

extension LoadingViewController {
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("ERROR saving items")
        }
    }
    
    func loadItems() {
        let request : NSFetchRequest<City> = City.fetchRequest()
        do {
            CityList.cityList = try context.fetch(request)
        } catch {
            print("ERROR loading items")
        }
    }
}

//MARK: - WeatherManagerDelegate methods

extension LoadingViewController: WeatherManagerDelegate {
    func didFail() {
        self.performSegue(withIdentifier: Identifiers.errorSegue, sender: self)
    }
}

//MARK: - CoreLocation methods

extension LoadingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            if let lon = locations.last?.coordinate.longitude , let lat = locations.last?.coordinate.latitude {
                WeatherManager.fetchWeatherForCurrentLocation(lon: lon, lat: lat)
                WeatherManagerForFive.fetchWeatherForForcast(lon: lon, lat: lat)
                LonAndLat.lat = lat
                LonAndLat.lon = lon
            } else {
                print("ERROR")
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR GETTING LOCATION")
    }
    
}

extension LoadingViewController: WeatherParametersDelegate {
    
    func hideLoading(params: WeatherParametersForCurrent) {
        self.params = params
        checkIfCityInDB(cityName: params.cityName)
        if cityName != nil {
            if Tracker.tracker {
                self.performSegue(withIdentifier: Identifiers.weatherSegue, sender: self)
            } else {
                let newCity = City(context: context)
                newCity.name = cityName?.replacingOccurrences(of: "%20", with: "-")
                newCity.country = params.country
                saveItems()
                self.performSegue(withIdentifier: Identifiers.weatherSegue, sender: self)
            }
        } else {
            self.performSegue(withIdentifier: Identifiers.weatherSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CityWeatherViewController
        destinationVC.params = params
    }
    
    func checkIfCityInDB(cityName: String) {
        for city in CityList.cityList {
            if city.name == cityName {
                Tracker.tracker = true
                break
            } else {
                Tracker.tracker = false
            }
        }
    }
}


