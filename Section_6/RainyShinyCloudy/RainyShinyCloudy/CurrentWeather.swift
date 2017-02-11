//
//  CurrentWeather.swift
//  RainyShinyCloudy
//
//  Created by Andrew Huber on 2/10/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import Alamofire

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
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        
        return _currentTemp
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = SuccinctDateFormatter(dateStyle: .long, timeStyle: .long)
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
    
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    
    typealias DownloadComplete = () -> ()
    func downloadWeatherDetails(completed: DownloadComplete) {
        // Alamofire download
        let currentWeatherURLString = Constants.getCurrentWeatherURL(withLatitude: 35, andWithLongitude: 139)
        let currentWeatherURL = URL(string: currentWeatherURLString)!
        Alamofire.request(currentWeatherURL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    let firstDict = weather[0]
                    
                    if let main = firstDict["main"] as? String {
                        self._weatherType = main.capitalized
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        let kelvinToFahrenheitNumerator = (currentTemperature * (9 / 5) - 459.67)
                        let kelvinToFahrenheitDenominator = 10.0
                        let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitNumerator / kelvinToFahrenheitDenominator))
                        self._currentTemp = kelvinToFahrenheit
                    }
                }
            }
            
            print(self)
        }
        completed()
    }
}
