//
//  Extensions.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 11.04.2023.
//

import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}

extension String {
    func formatCityName() -> String {
        return self.replacingOccurrences(of: "-", with: "%20")
            .replacingOccurrences(of: " ", with: "%20")
    }
}
