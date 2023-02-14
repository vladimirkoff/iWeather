//
//  WeatherManagerForFive.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 14.02.2023.
//

import Foundation

protocol WeatherManagerForFiveDelegate {
    func didFailWithError()
    func didUpdated(weather: [WeatherModelClass])
}

struct WeatherManagerForFive {
    
    var delegate: WeatherManagerForFiveDelegate?

     func fetchWeatherForFiveDays(city: String? = nil, lon: Double? = nil, lat: Double? = nil) {
         var tracker = true
        if let cityName = city {
            Urls.weatherForFiveDays += "q=\(cityName)" + Identifiers.apiKey
            tracker = true
        } else {
            Urls.weatherUrlForFiveWithLocation += "lat=\(lat!)&lon=\(lon!)" + Identifiers.apiKey
            tracker = false
        }
         performRequestForFiveDays(tracker: tracker)
    }
    func performRequestForFiveDays(tracker: Bool) {
        var test = ""
        if tracker {
            test = Urls.weatherForFiveDays
        } else {
            test = Urls.weatherUrlForFiveWithLocation
        }
        print(test)
        if let url = URL(string: test) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print("BIIIG ERROR")
                }
                if let safeData = data {
                       parseJSONforFiveDays(data: safeData)
                }
            }
            Urls.updateWeatherUrl()
            task.resume()
        }
    }
    func parseJSONforFiveDays(data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherModelForFiveDays.self, from: data)
            let arrayOfTemps = decodedData.list
            
            for time in arrayOfTemps {
                if time.dt_txt.dropFirst(11).prefix(13) == "15:00:00" {
                    var icon = ""
                    switch time.weather[0].id {
                    case 200...232: icon = "cloud.bolt"
                    case 300...321: icon = "cloud.drizzle.fill"
                    case 500...531: icon = "cloud.rain.fill"
                    case 600...622: icon = "cloud.snow.fill"
                    case 701...781: icon = "cloud.fog.fill"
                    case 800: icon = "sun.max.fill"
                    case 801...804: icon = "cloud.fill"
                    default: icon = ""
                    }
                    WeatherArray.weatherArray.append(WeatherModelClass(time: time.dt_txt, temp: time.main.temp, icon: icon))
                }
            }
        } catch {
            print("ERROR parsing JSONcfx")
        }
    }
}
