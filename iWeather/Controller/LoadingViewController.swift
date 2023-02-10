//
//  LoadingViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit

class LoadingViewController: UIViewController, WeatherManagerDelegate {
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
    }
    func didFail() {
        print("AN ERROR OCCURED")
    }
    
    func didUpdateUI() {
        print("Success")
    }
}
