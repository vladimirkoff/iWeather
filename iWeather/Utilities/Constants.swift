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
    static let cityCell = "CityCustomCell"
    static let weatherCell = "WeatherCustomCell"
    static let goBackSegue = "goBackToInitial"
    static let goBackFromWeather = "goBackFromWeather"
    static let apiKey = "&appid=19d05a5ed37fa14c551db44956ae91aa"
}

struct Urls {
    static var urlForCurrentInfo = "https://schedule.kpi.ua/api/time/current"
    static var weatherUrlForcastWithLocation = "api.openweathermap.org/data/2.5/forecast?"
    static var currentWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=19d05a5ed37fa14c551db44956ae91aa&units=metric"
    static var weatherForCurrentLocation = "https://api.openweathermap.org/data/2.5/weather?&units=metric&"
    static var weatherForcast = "https://api.openweathermap.org/data/2.5/forecast?&units=metric&"
}
