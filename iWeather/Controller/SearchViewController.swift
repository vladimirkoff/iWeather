//
//  SearchViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit
import CoreData
import SwipeCellKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var appearanceSwitcher: UISwitch!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backGround: UIView!
    
    let defaults = UserDefaults.standard
    var cityName: String?
   
    let weatherManager = WeatherManager()
    let weatherManagerForFive = WeatherManagerForFive()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.dataSource = self
        tableView.delegate = self
        loadItems()
        Tracker.mode = defaults.bool(forKey: "mode")
        appearanceSwitcher.isOn = Tracker.mode
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
    }
    
    @IBAction func appearanceSwitched(_ sender: UISwitch) {
        Tracker.mode = !Tracker.mode
        defaults.set(Tracker.mode, forKey: "mode")
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Identifiers.loadingSegue, sender: self)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if searchField.text! == "" {
            emptyFieldAlert()
            return
        }
        for char in searchField.text! {   // checks if there are spaces in a String
            if char == " " && ( searchField.text?.last == char || searchField.text?.first == char ) {
                invalidSyntaxAlert()
                return
            }
            else if Int(String(char)) != nil {   // checks if there are numbers in a string
                invalidSyntaxAlert()
                return
            }
        }
        cityName = searchField.text!
        performSegue(withIdentifier: Identifiers.loadingSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! LoadingViewController
        if cityName == nil {
            return
        } else {
            weatherManagerForFive.fetchWeatherForFiveDays(city: cityName!)
            destinationVC.cityName = self.cityName
            for city in CityList.cityList {
            if city.name == cityName! {
                Tracker.tracker = true
                break
            } else {
                Tracker.tracker = false
            }
        }
    }
  }
}

//MARK: - UITableView methods

extension SearchViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CityList.cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.cityCell, for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = CityList.cityList[indexPath.row].name
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityName = CityList.cityList[indexPath.row].name
        performSegue(withIdentifier: Identifiers.loadingSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.context.delete(CityList.cityList[indexPath.row])
            CityList.cityList.remove(at: indexPath.row)
            self.saveItems()
            tableView.reloadData()
        }
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
}

//MARK: - CoreData methods

extension SearchViewController {
    func loadItems() {
        let request : NSFetchRequest<City> = City.fetchRequest()
        do {
            CityList.cityList = try context.fetch(request)
        } catch {
            print("ERROR loading items")
        }
        tableView.reloadData()
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("ERROR saving items")
        }
    }
}

//MARK: - Alerts

extension SearchViewController {
    func emptyFieldAlert() {
        let alert = UIAlertController(title: "Please, enter city name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .default) { action in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func invalidSyntaxAlert() {
        let alert = UIAlertController(title: "Invalid syntax", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .default) { action in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
  }

