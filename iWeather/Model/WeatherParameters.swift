//
//  WeatherParameters.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 11.02.2023.
//

import Foundation
import CoreData

protocol WeatherParametersDelegate {
    func hideLoading(params: WeatherParametersForCurrent)
}


struct WeatherParametersForCurrent {
    
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
        
        WeatherParametersForCurrent.delegate?.hideLoading(params: self)
    }
}

struct CityList {
    static var cityList = [City]()
}

class WeatherModelClass {
    var time: String
    var temp: Int
    var icon: String
    var day: Int
    
    init(time: String, temp: Int, icon: String, day: Int) {
        self.time = time
        self.temp = temp
        self.icon = icon
        self.day = day
    }
}

struct WeatherArray {
    static var weatherArray = [WeatherModelClass]()
    
    static func updateWeatherArray() {
        weatherArray.removeAll()
    }
}

struct DaysArray {
    static let daysArray = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
}

struct CurrentDayValue {
    static var day: Int?
}

struct LonAndLat {
    static var lon: Double?
    static var lat: Double?
}
