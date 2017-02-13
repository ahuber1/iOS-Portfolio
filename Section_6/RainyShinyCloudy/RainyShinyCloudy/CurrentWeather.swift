//
//  CurrentWeather.swift
//  RainyShinyCloudy
//
//  Created by Andrew Huber on 2/10/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class CurrentWeather: CustomStringConvertible {
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        
        return _weatherType
    }
    
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        
        let temperatureUnit: TemperatureUnit
        
        if let delegate = temperatureUnitDelegate {
            temperatureUnit = delegate.temperatureUnitSelected
        }
        else {
            temperatureUnit = .kelvin
        }
        
        return formatAndConvertTemperatureInKelvin(_currentTemp, to: temperatureUnit)
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = SuccinctDateFormatter(dateStyle: .long, timeStyle: .none)
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    var description: String {
        let line1 = date
        let line2 = "City Name: \(cityName)"
        let line3 = "Weather Type: \(weatherType)"
        let line4 = "Current Temperature: \(currentTemp)"
        return "\(line1)\n\(line2)\n\(line3)\n\(line4)"
    }
    
    var temperatureUnitDelegate: TemperatureUnitDelegate?
    
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    
    func downloadWeatherDetails(atLocation location: CLLocation, _ completed: @escaping DownloadComplete) {
        // Alamofire download
        let currentWeatherURLString = getCurrentWeatherURL(atLocation: location)
        let currentWeatherURL = URL(string: currentWeatherURLString)!
        Alamofire.request(currentWeatherURL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                }
                else {
                    print("Unable to set _cityName")
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    let firstDict = weather[0]
                    
                    if let main = firstDict["main"] as? String {
                        self._weatherType = main.capitalized
                    }
                    else {
                        print("Unable to set _weatherType")
                    }
                }
                else {
                    print("Unable to get \"weather\" array")
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        self._currentTemp = currentTemperature
                    }
                    else {
                        print("Unable to set _currentTemp")
                    }
                }
                else {
                    print("Unable to get \"main\" dictionary")
                }
            }
            else {
                print("Unable to read outermost dictionary")
            }
            
            completed()
        }
    }
}
