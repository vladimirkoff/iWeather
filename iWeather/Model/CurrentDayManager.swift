//
//  CurrentDayManager.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 15.02.2023.
//

import Foundation

struct CurrentDayManager {
    func performRequestForCurrentInfo() -> Void {
        if let url = URL(string: Urls.urlForCurrentInfo) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print("ERROR getting current day - \(e)")
                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        parseJSON(data: safeData)
                    }    
                }
            }
            task.resume()
        }
    }
    func parseJSON(data: Data) -> Void {
        let decoder = JSONDecoder()
        do {
            let decodedData =  try decoder.decode(CurrentData.self, from: data)
                CurrentDayValue.day = decodedData.data.currentDay - 1
        } catch {
           print("ERROR parsing JSON for current day - \(error)")
        }
    }
}
