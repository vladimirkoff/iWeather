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
        print(Urls.weatherUrl)
        if let url = URL(string: Urls.weatherUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print("Error occured - \(e)")
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
            print(decodedData.main.humidity)
            print(decodedData.visibility)
            print(decodedData.main.temp)
            print(decodedData.wind.speed)
            delegate?.didUpdateUI()
        } catch {
            print("Error decoding data")
        }
    }
}
