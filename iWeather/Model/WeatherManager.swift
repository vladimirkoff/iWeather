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
        
        Urls.weatherUrl += "&q=\(city)"
        performRequest()
    }
    
    func performRequest() {
        if let url = URL(string: Urls.weatherUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print("Error performing request - \(e)")
                    delegate?.didFail()
                } else {
                   
                    if let safeData = data {
                            parseJSON(data: safeData)
                    }
                }
            }
            task.resume()
            Urls.updateWeatherUrl()
        }
    }
    
    func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherModel.self, from: data)
            WeatherParameters.country = decodedData.sys.country
            WeatherParameters.visibility = decodedData.visibility
            WeatherParameters.humidity = decodedData.main.humidity
            WeatherParameters.temp = decodedData.main.temp
            WeatherParameters.speed = decodedData.wind.speed
            delegate?.didUpdateUI()
        } catch {
            print("Error parsing JSON - \(error)")
            delegate?.didFail()
        }
    }
}
