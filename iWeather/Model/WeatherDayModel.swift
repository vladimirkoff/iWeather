//
//  WeatherDayModel.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 11.04.2023.
//

import Foundation

class WeatherDayModel {
    var time: String
    var temp: Int
    var icon: String
    var day: String
    
    init(time: String, temp: Int, icon: String, day: String) {
        self.time = time
        self.temp = temp
        self.icon = icon
        self.day = day
    }
}
