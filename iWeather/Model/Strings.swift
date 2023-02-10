//
//  Strings.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import Foundation

struct Identifiers {
    static let errorSegue = "goToError"
    static let loadingSegue = "goToLoading"
    static let weatherSegue = "goToWeather"
    static let cityCell = "CityCell"
}

struct Urls {
    static var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=19d05a5ed37fa14c551db44956ae91aa&units=metric"
    static func updateWeatherUrl() {
        weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=19d05a5ed37fa14c551db44956ae91aa&units=metric"
    }
}
