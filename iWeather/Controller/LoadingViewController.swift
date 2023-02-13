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
    var weatherManager = WeatherManager()
    var tracker: Bool?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        locationManager.delegate = self
        weatherManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if cityName != nil {
            weatherManager.fetchWeather(city: cityName!)
        } else {
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
            Test.cityList = try context.fetch(request)
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
                newCity.name = cityName
                newCity.country = WeatherParameters.country
                saveItems()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Identifiers.weatherSegue, sender: self)
                }
            }
        } else {
            print("Updated")
            self.performSegue(withIdentifier: Identifiers.weatherSegue, sender: self)
        }
          
         
    }
}

//MARK: - CoreLocation methods

extension LoadingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            if let lon = locations.last?.coordinate.longitude , let lat = locations.last?.coordinate.latitude {
                self.weatherManager.fetchWeatherForCurrentLocation(lon: lon, lat: lat)
            } else {
                print("ERROR")
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR GETTING LOCATION")
    }
}
