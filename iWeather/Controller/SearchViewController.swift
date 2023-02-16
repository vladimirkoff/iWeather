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
    
    @IBOutlet var moonImage: UIImageView!
    @IBOutlet var sunImage: UIImageView!
    @IBOutlet weak var appearanceSwitcher: UISwitch!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backGround: UIView!
    @IBOutlet var tableViewBackCol: UITableView!
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cityName: String?
    var cityNameCopy: String?
    
    let currentDayManager = CurrentDayManager()
    let weatherManager = WeatherManager()
    let weatherManagerForFive = WeatherManagerForFive()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        Tracker.mode = defaults.bool(forKey: "mode")
        tableViewBackCol.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        appearanceSwitcher.isOn = Tracker.mode
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        
        DispatchQueue.main.async {
            self.currentDayManager.performRequestForCurrentInfo()
        }
        
        searchField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        loadItems()
        
        
      
        if Tracker.mode {
            moonImage.image = UIImage(systemName: "moon.fill")
            moonImage.tintColor = .white
        } else {
            sunImage.image = UIImage(systemName: "sun.max.fill")
            sunImage.tintColor = .yellow
        }
        
        
        tableView.register(UINib(nibName: "CityCustomCell", bundle: nil), forCellReuseIdentifier: Identifiers.cityCell)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchWeather()
    }
    
    @IBAction func appearanceSwitched(_ sender: UISwitch) {
        Tracker.mode = !Tracker.mode
        tableView.reloadData()
        tableViewBackCol.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        if Tracker.mode {
            moonImage.image = UIImage(systemName: "moon.fill")
            moonImage.tintColor = .white
            sunImage.image = nil
        } else {
            sunImage.image = UIImage(systemName: "sun.max.fill")
            sunImage.tintColor = .yellow
            moonImage.image = nil
        }
        defaults.set(Tracker.mode, forKey: "mode")
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Identifiers.loadingSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! LoadingViewController
        if cityName == nil {
            return
        } else {
            DispatchQueue.main.async {
                self.weatherManagerForFive.fetchWeatherForFiveDays(city: self.cityName!)
                
            }
            destinationVC.cityNameCopy = self.cityNameCopy
            destinationVC.cityName = self.cityName
            for city in CityList.cityList {
                print(cityNameCopy!)
            if city.name == cityNameCopy! {
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.cityCell, for: indexPath) as! CityCustomCell
        cell.backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
        cell.cityLabel?.text = CityList.cityList[indexPath.row].name
        cell.countryLabel?.text = CityList.cityList[indexPath.row].country
        cell.cityLabel?.textColor = .white
        cell.countryLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Futura", size: 25)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityNameCopy = CityList.cityList[indexPath.row].name!
        cityName = CityList.cityList[indexPath.row].name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.replacingOccurrences(of: "-", with: "%20")
        performSegue(withIdentifier: Identifiers.loadingSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        self.context.delete(CityList.cityList[indexPath.row])
        CityList.cityList.remove(at: indexPath.row)
        self.saveItems()
        }
        deleteAction.image = UIImage(named: "trash")
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

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchWeather()
        return true
    }
}

//MARK: - SearchForWeather function

extension SearchViewController {
    func searchWeather() {
        if searchField.text! == "" {
        emptyFieldAlert()
        return
}
        let cityString = searchField.text!
        for char in cityString {   // checks if there are spaces in a String
             if Int(String(char)) != nil {   // checks if there are numbers in a string
                invalidSyntaxAlert()
                return
             }
        }
        cityNameCopy = cityString.replacingOccurrences(of: " ", with: "-")
        cityName = cityString.trimmingCharacters(in: .whitespaces).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.replacingOccurrences(of: "-", with: "%20")
      performSegue(withIdentifier: Identifiers.loadingSegue, sender: self)
    }
}

