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
    static let goBackSegue = "goBackToInitial"
    static let goBackFromWeather = "goBackFromWeather"
    static let apiKey = "&appid=19d05a5ed37fa14c551db44956ae91aa"
}

struct Urls {
    static var weatherUrlForFiveWithLocation = "api.openweathermap.org/data/2.5/forecast?"
    static var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=19d05a5ed37fa14c551db44956ae91aa&units=metric"
    static func updateWeatherUrl() {
        weatherForCurrentLocation = "https://api.openweathermap.org/data/2.5/weather?"
        weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=19d05a5ed37fa14c551db44956ae91aa&units=metric"
        weatherForFiveDays = "https://api.openweathermap.org/data/2.5/forecast?"
        weatherUrlForFiveWithLocation = "https://api.openweathermap.org/data/2.5/forecast?"
    }
    static var weatherForCurrentLocation = "https://api.openweathermap.org/data/2.5/weather?"
    static var weatherForFiveDays = "https://api.openweathermap.org/data/2.5/forecast?"
}
