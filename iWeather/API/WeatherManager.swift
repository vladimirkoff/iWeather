//
//  WeatherManager.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import Foundation

protocol WeatherManagerDelegate {
    func didFail()
    func didUpdateUI()
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String) {
        Urls.currentWeatherUrl += "&q=\(city)"
        performRequest(cityName: city)
    }
    
    func fetchWeatherForCurrentLocation(lon: Double, lat: Double) {
        Urls.weatherForCurrentLocation += "lon=\(lon)&lat=\(lat)&appid=19d05a5ed37fa14c551db44956ae91aa"
        performRequest(lon: lon, lat: lat)
    }
    
    func performRequest(lon: Double? = nil, lat: Double? = nil, cityName: String? = nil) {
        var currentUrl = ""
        if lon == nil || lat == nil {
            currentUrl = Urls.currentWeatherUrl
        } else {
            currentUrl = Urls.weatherForCurrentLocation
        }
        if let url = URL(string: currentUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print("Error performing request - \(e)")
                    delegate?.didFail()
                } else {
                    if let safeData = data {
                            parseJSON(data: safeData, cityName: cityName)
                    }
                }
            }
            task.resume()
            Urls.updateWeatherUrl()
        }
    }
    
    func parseJSON(data: Data, cityName: String? = nil) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherModel.self, from: data)
            WeatherParametersForCurrent.country = decodedData.sys.country
            WeatherParametersForCurrent.visibility = decodedData.visibility
            WeatherParametersForCurrent.humidity = decodedData.main.humidity
            WeatherParametersForCurrent.temp = decodedData.main.temp
            WeatherParametersForCurrent.speed = decodedData.wind.speed
            WeatherParametersForCurrent.min = Int(decodedData.main.temp_min)
            WeatherParametersForCurrent.max = Int(decodedData.main.temp_max)
            WeatherParametersForCurrent.description = decodedData.weather[0].description
            WeatherParametersForCurrent.pressure = decodedData.main.pressure
            WeatherParametersForCurrent.feels_like = Int(decodedData.main.feels_like)
            if let city = cityName {WeatherParametersForCurrent.cityName = city} else {WeatherParametersForCurrent.cityName = decodedData.name}
            delegate?.didUpdateUI()
        } catch {
            print("Error parsing JSON - \(error)")
            delegate?.didFail()
        }
    }
}
