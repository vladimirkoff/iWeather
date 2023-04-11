//
//  WeatherManager.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import Foundation

protocol WeatherManagerDelegate {
    func didFail()
}

struct WeatherManager {
    
   static var delegate: WeatherManagerDelegate?
    
    static func fetchWeather(city: String) {
        Urls.currentWeatherUrl += "&q=\(city)"
        performRequest(cityName: city)
    }
    
    static func fetchWeatherForCurrentLocation(lon: Double, lat: Double) {
        Urls.weatherForCurrentLocation += "lon=\(lon)&lat=\(lat)&appid=19d05a5ed37fa14c551db44956ae91aa"
        print(Urls.weatherForCurrentLocation)
        performRequest(lon: lon, lat: lat)
    }
    
    static func performRequest(lon: Double? = nil, lat: Double? = nil, cityName: String? = nil) {
        var currentUrl = ""
        
        currentUrl = cityName == nil ? Urls.weatherForCurrentLocation : Urls.currentWeatherUrl
        
        if let url = URL(string: currentUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print("Error performing request - \(e)")
                    DispatchQueue.main.async {
                        self.delegate?.didFail()
                    }
                    return
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
    
    static func parseJSON(data: Data, cityName: String? = nil) {
        let decoder = JSONDecoder()
 
        do {
            let decodedData = try decoder.decode(WeatherModel.self, from: data)
           
            DispatchQueue.main.async {
                let weatherParameters = WeatherParametersForCurrent(description: decodedData.weather[0].description, cityName: decodedData.name, humidity: decodedData.main.humidity, visibility: decodedData.visibility, country: decodedData.sys.country, speed: decodedData.wind.speed, temp: decodedData.main.temp, min: Int(decodedData.main.temp_min), max: Int(decodedData.main.temp_max), feels_like: Int(decodedData.main.feels_like), pressure: decodedData.main.pressure)
            }
            
        } catch {
            print("Error parsing JSON - \(error)")
            DispatchQueue.main.async {
                self.delegate?.didFail()
            }
        }
    }
}
