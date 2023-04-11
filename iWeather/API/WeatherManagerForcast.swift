//
//  WeatherManagerForFive.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 14.02.2023.
//

import Foundation

struct WeatherManagerForFive {
    
    static func fetchWeatherForecast(city: String? = nil, lon: Double? = nil, lat: Double? = nil, completion: @escaping([WeatherDayModel]) -> ()) {
        
        let url = configureURL(city: city, lon: lon, lat: lat )
        
        if let url = url {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let e = error {
                    print("ERROR performing task - \(e.localizedDescription)")
                    return
                }
                if let safeData = data {
                    var weatherArray = [WeatherDayModel]()
                    DispatchQueue.main.async {
                        do {
                            let decodedData = try JSONDecoder().decode(WeatherModelForFiveDays.self, from: safeData)
                            let arrayOfTemps = decodedData.list
                            for weather in arrayOfTemps {
                                if weather.dt_txt.dropFirst(11).prefix(13) == "15:00:00" {
                                    let day = getDayOfWeek(date: String(weather.dt_txt.dropFirst(0).prefix(10)))
                                    let icon = chooseIconForWeather(id: weather.weather[0].id)
                                    weatherArray.append(WeatherDayModel(time: weather.dt_txt, temp: Int(weather.main.temp), icon: icon, day: day))
                                }
                            }
                            completion(weatherArray)
                        } catch {
                            print("ERROR parsing JSON - \(error)")
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    static func getDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date)
    }
    
    static func getDayOfWeek(date: String) -> String {
        let day = String(getDate(date: date)!.dayOfWeek()!.prefix(3))
        return day
    }
    
    static private func chooseIconForWeather(id: Int) -> String {
        var icon = ""
        switch id {
        case 200...232: icon = "cloud.bolt"
        case 300...321: icon = "cloud.drizzle.fill"
        case 500...531: icon = "cloud.rain.fill"
        case 600...622: icon = "cloud.snow.fill"
        case 701...781: icon = "cloud.fog.fill"
        case 800: icon = "sun.max.fill"
        case 801...804: icon = "cloud.fill"
        default: icon = ""
        }
        return icon
    }
    
    static func configureURL(city: String? = nil, lon: Double? = nil, lat: Double? = nil) -> URL? {
        let urlString = city == nil ?
        Urls.weatherUrlForcastWithLocation + "lat=\(lat!)&lon=\(lon!)" + Identifiers.apiKey :
        Urls.weatherForcast + "q=\(city!)" + Identifiers.apiKey
        let url = URL(string: urlString)
        print(urlString)
        return url
    }
    
}


