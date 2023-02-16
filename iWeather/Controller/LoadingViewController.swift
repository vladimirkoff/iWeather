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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cityName: String?
    var cityNameCopy: String?
    var tracker: Bool?
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    let weatherManagerForFive = WeatherManagerForFive()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        locationManager.delegate = self
        weatherManager.delegate = self
        DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()

        }
        
        if cityName != nil {
                self.weatherManager.fetchWeather(city: self.cityName!)
        };
        if let lat = LonAndLat.lat, let lon = LonAndLat.lon {
            self.weatherManager.fetchWeatherForCurrentLocation(lon: lon, lat: lat)
            self.weatherManagerForFive.fetchWeatherForForcast(lon: lon, lat: lat)
        }
        else {
            locationManager.requestLocation()
        }
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
        print("ERROR")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Identifiers.errorSegue, sender: self)
        }
    }
    
    func didUpdateUI() {
        if cityName != nil {
            if Tracker.tracker {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Identifiers.weatherSegue, sender: self)
                }
            } else {
                let newCity = City(context: context)
                newCity.name = cityName?.replacingOccurrences(of: "%20", with: "-")
                newCity.country = WeatherParametersForCurrent.country
                saveItems()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Identifiers.weatherSegue, sender: self)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Identifiers.weatherSegue, sender: self)
            }
            
        }
    }
}

//MARK: - CoreLocation methods

extension LoadingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            if let lon = locations.last?.coordinate.longitude , let lat = locations.last?.coordinate.latitude {
                self.weatherManager.fetchWeatherForCurrentLocation(lon: lon, lat: lat)
                self.weatherManagerForFive.fetchWeatherForForcast(lon: lon, lat: lat)
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
