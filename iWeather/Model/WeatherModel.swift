//
//  WeatherModel.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import Foundation

struct WeatherModel: Codable {
    var weather: [Weather]
    var main: Main
    var visibility: Int
    var wind: Wind
}

struct Weather: Codable {
    var main: String
}

struct Main: Codable {
    var temp: Double
    var feels_like: Double
    var pressure: Int
    var humidity: Int
}

struct Wind: Codable {
    var speed: Double
}

