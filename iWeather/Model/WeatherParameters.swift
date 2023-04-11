//
//  WeatherParameters.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 11.02.2023.
//

import Foundation
import CoreData

protocol WeatherParametersDelegate {
    func hideLoading(params: WeatherParameters)
}


struct WeatherParameters {
    
    static var delegate: WeatherParametersDelegate?
    
    var description: String
    var cityName: String
    var humidity: Int
    var visibility: Int
    var country: String
    var speed: Double
    var temp: Double
    var min: Int
    var max: Int
    var feels_like: Int
    var pressure: Int
    
    init(description: String, cityName: String, humidity: Int, visibility: Int, country: String, speed: Double, temp: Double, min: Int, max: Int, feels_like: Int, pressure: Int) {
        self.description = description
        self.cityName = cityName
        self.humidity = humidity
        self.visibility = visibility
        self.country = country
        self.speed = speed
        self.temp = temp
        self.min = min
        self.max = max
        self.feels_like = feels_like
        self.pressure = pressure
        
        WeatherParameters.delegate?.hideLoading(params: self)
    }
}









