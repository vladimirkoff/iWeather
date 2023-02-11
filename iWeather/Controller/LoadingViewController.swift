//
//  LoadingViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit
import CoreData

class LoadingViewController: UIViewController, WeatherManagerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cityName: String?
    var weatherManager = WeatherManager()
    var tracker: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cityName!)
        weatherManager.delegate = self
        weatherManager.fetchWeather(city: cityName!)
    }
    func didFail() {
        print("ERROR")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Identifiers.errorSegue, sender: self)
        }
    }
    
    func didUpdateUI() {
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
    }
    
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
