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
    
    
    var cityName: String?  {
        didSet { WeatherManager.performRequest(cityName: cityName!) }
    }
    
    var tracker: Bool?
    
    var params: WeatherParameters?
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Tracker.isForCurrent {
            if let lat = LonAndLat.lat, let lon = LonAndLat.lon {
                WeatherManager.performRequest(lon: lon, lat: lat)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        WeatherParameters.delegate = self
        WeatherManager.delegate = self
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.errorSegue { return }
        let destinationVC = segue.destination as! CityWeatherViewController
        destinationVC.params = params
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

//MARK: - WeatherManagerDelegate methods

extension LoadingViewController: WeatherManagerDelegate {
    func didFail() {
        self.performSegue(withIdentifier: Identifiers.errorSegue, sender: self)
    }
}

//MARK: - WeatherParametersDelegate

extension LoadingViewController: WeatherParametersDelegate {
    
    func hideLoading(params: WeatherParameters) {
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
}


