//
//  Forecast.swift
//  RainyShinyCloudy
//
//  Created by Andrew Huber on 2/11/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import Alamofire

class Forecast: CustomStringConvertible {
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = 0.0
        }
        
        let temperatureUnit: TemperatureUnit
        
        if let delegate = temperatureUnitDelegate {
            temperatureUnit = delegate.temperatureUnitSelected
        }
        else {
            temperatureUnit = .kelvin
        }
        
        return formatAndConvertTemperatureInKelvin(_highTemp, to: temperatureUnit)
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = 0.0
        }
        
        let temperatureUnit: TemperatureUnit
        
        if let delegate = temperatureUnitDelegate {
            temperatureUnit = delegate.temperatureUnitSelected
        }
        else {
            temperatureUnit = .kelvin
        }
        
        return formatAndConvertTemperatureInKelvin(_lowTemp, to: temperatureUnit)
    }
    
    var description: String {
        let line1 = "Date: \(date)"
        let line2 = "Weather Type: \(weatherType)"
        let line3 = "High Temperature: \(highTemp)"
        let line4 = "Low Temperature: \(lowTemp)"
        return "\(line1)\n\(line2)\n\(line3)\n\(line4)"
    }
    
    var temperatureUnitDelegate: TemperatureUnitDelegate?
    
    private var _date: String!
    private var _weatherType: String!
    private var _highTemp: Double!
    private var _lowTemp: Double!
    
    init (weatherDict: Dictionary<String, AnyObject>) {
        if let temp = weatherDict["temp"]  as? Dictionary<String, AnyObject> {
            if let min = temp["min"] as? Double {
                _lowTemp = min
            }
            else {
                print("_lowTemp could not be set")
            }
            if let max = temp["max"] as? Double {
                _highTemp = max
            }
            else {
                print("_highTemp could not be set")
            }
            if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
                if let main = weather[0]["main"] as? String {
                    self._weatherType = main
                }
                else {
                    print("_weatherType could not be set")
                }
            }
            else {
                print("weather could not be set")
            }
            if let date = weatherDict["dt"] as? Double {
                let unixConvertedDate = Date(timeIntervalSince1970: date)
                self._date = unixConvertedDate.dayOfTheWeek
            }
            else {
                print("_date could not be set")
            }
        }
        else {
            print("temp could not be set")
        }
    }
}

extension Date {
    var dayOfTheWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
