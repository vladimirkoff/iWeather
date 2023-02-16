//
//  WeatherManagerForFive.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 14.02.2023.
//

import Foundation

struct WeatherManagerForFive {
    
     func fetchWeatherForForcast(city: String? = nil, lon: Double? = nil, lat: Double? = nil) {
         var url = ""
        if let cityName = city {
            Urls.weatherForcast += "q=\(cityName)" + Identifiers.apiKey
            url = Urls.weatherForcast
        } else {
            Urls.weatherUrlForcastWithLocation += "lat=\(lat!)&lon=\(lon!)" + Identifiers.apiKey
            url = Urls.weatherUrlForcastWithLocation
        }
         DispatchQueue.main.async {
             performRequestForForcast(url: url)
         }
    }
    
    func performRequestForForcast(url: String) {
        print(url)
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print("ERROR performing task - \(e)")
                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        parseJSONforForcasts(data: safeData)
                    }
                    }
                }
            
            Urls.updateWeatherUrl()
            task.resume()
        }
    }
    
    func parseJSONforForcasts(data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherModelForFiveDays.self, from: data)
            let arrayOfTemps = decodedData.list
            for weather in arrayOfTemps {
                if weather.dt_txt.dropFirst(11).prefix(13) == "15:00:00" {
                    var icon = ""
                    switch weather.weather[0].id {
                    case 200...232: icon = "cloud.bolt"
                    case 300...321: icon = "cloud.drizzle.fill"
                    case 500...531: icon = "cloud.rain.fill"
                    case 600...622: icon = "cloud.snow.fill"
                    case 701...781: icon = "cloud.fog.fill"
                    case 800: icon = "sun.max.fill"
                    case 801...804: icon = "cloud.fill"
                    default: icon = ""
                    }
                    WeatherArray.weatherArray.append(WeatherModelClass(time: weather.dt_txt, temp: Int(weather.main.temp), icon: icon, day:CurrentDayValue.day!))
                }
            }
        } catch {
            print("ERROR parsing JSON - \(error)")
        }
    }
}
