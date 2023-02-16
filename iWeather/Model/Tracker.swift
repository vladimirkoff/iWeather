//
//  Tracker.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import Foundation

struct Tracker {
    static var mode = false  // keeps the state of appearance ( false - light, true - dark )
    static var tracker = false   // keeps track of wether the city has already been added to the DB
    static var count: Int = CurrentDayValue.day! {   // tracks the day of the week
        willSet{
        }
        didSet {
            if count == 7 {
                count = 0
            }
        }
    }
}
