//
//  WeatherParameters.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 11.02.2023.
//

import Foundation
import CoreData

struct WeatherParametersForCurrent {
    static var description = ""
    static var cityName = ""
    static var humidity = 0
    static var visibility = 0
    static var country = ""
    static var speed = 0.0
    static var temp = 0.0
    static var min = 0.0
    static var max = 0.0
}

struct CityList {
    static var cityList = [City]()
}

class WeatherModelClass {
    var time: String
    var temp: Double
    var icon: String
    
    init(time: String, temp: Double, icon: String) {
        self.time = time
        self.temp = temp
        self.icon = icon
    }
}

struct WeatherArray {
    static var weatherArray = [WeatherModelClass]()
    static func updateWeatherArray() {
        weatherArray.removeAll()
    }
}

struct DaysArray {
    static let daysArray = ["Mon", "Tue", "Wed", "Thu", "Fri"]
}
