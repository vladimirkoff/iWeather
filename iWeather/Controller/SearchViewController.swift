//
//  SearchViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let weatherManager = WeatherManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cityList = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.dataSource = self
        loadItems()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.cityCell, for: indexPath)
        
        cell.textLabel?.text = cityList[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        print("Selected")
//        let newCity = City(context: context)
//        newCity.name = searchField.text!
//        newCity.country = "undefined"
//        cityList.append(newCity)
//        saveItems()

       
            self.weatherManager.fetchWeather(city: self.searchField.text!)
        
        performSegue(withIdentifier: Identifiers.loadingSegue, sender: self)
        
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
            cityList = try context.fetch(request)
        } catch {
            print("ERROR loading items")
        }
        tableView.reloadData()
    }
}
