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
    
    static func configureURL(lon: Double? = nil, lat: Double? = nil, cityName: String? = nil) -> URL? {
        var urlString = ""
        if let cityName = cityName {
            urlString = Urls.currentWeatherUrl + "&q=\(cityName)&\(Identifiers.apiKey)"
        } else {
            urlString = Urls.weatherForCurrentLocation + "lon=\(lon!)&lat=\(lat!)\(Identifiers.apiKey)"
        }
        print(urlString)
        return URL(string: urlString)
    }
    
    static func performRequest(lon: Double? = nil, lat: Double? = nil, cityName: String? = nil) {
        
        let url = cityName == nil ? configureURL(lon: lon, lat: lat) : configureURL(cityName: cityName)
        
        if let url = url {
            URLSession.shared.dataTask(with: url) { data, response, error in
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
            .resume()
        }
    }
    
    static func parseJSON(data: Data, cityName: String? = nil) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherModel.self, from: data)
            
            let cityName = decodedData.name
            let description = decodedData.weather[0].description
            let humidity = decodedData.main.humidity
            let visibility = decodedData.visibility
            let speed = decodedData.wind.speed
            let temp = decodedData.main.temp
            let country = decodedData.sys.country // refactor
            let pressure = decodedData.main.pressure
            let feels_like = Int(decodedData.main.feels_like)
            let max = Int(decodedData.main.temp_max)
            let min = Int(decodedData.main.temp_min)
            
            DispatchQueue.main.async {
                let weatherParameters = WeatherParameters(description: description, cityName: cityName, humidity: humidity, visibility: visibility, country: country, speed: speed, temp: temp, min: min, max: max, feels_like: feels_like, pressure: pressure)
            }
        } catch {
            print("Error parsing JSON - \(error)")
            DispatchQueue.main.async {
                self.delegate?.didFail()
            }
        }
    }
    
}
