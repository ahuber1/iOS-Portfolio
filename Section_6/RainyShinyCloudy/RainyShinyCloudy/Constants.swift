//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by Andrew Huber on 2/10/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import Foundation
import CoreLocation

typealias DownloadComplete = () -> ()

let NOT_SET = "— —"

func getCurrentWeatherURL(atLocation location: CLLocation) -> String {
    let (lat, lon) = getLatitudeAndLongitude(fromCLLocation: location)
    return getCurrentWeatherURL(withLatitude: lat, andWithLongitude: lon)
}

func getForecastWeatherURL(atLocation location: CLLocation) -> String {
    let (lat, lon) = getLatitudeAndLongitude(fromCLLocation: location)
    return getForecastWeatherURL(withLatitude: lat, andWithLongitude: lon)
}

func formatAndConvertTemperatureInKelvin(_ temperature: Double, to unit: TemperatureUnit) -> String {
    let convertedTemperature = convertTemperatureInKelvin(temperature, to: unit)
    let roundedTemperature = String(format: "%.1f", convertedTemperature)
    let ending: String
    
    switch unit {
    case .celsius:
        ending = "°C"
    case .fahrenheit:
        ending = "°F"
    default:
        ending = " K"
    }
    
    return "\(roundedTemperature)\(ending)"
}

func convertTemperatureInKelvin(_ temperature: Double, to unit: TemperatureUnit) -> Double {
    switch unit {
    case .fahrenheit:
        return Double(round(10 * (temperature * (9 / 5) - 459.67) / 10))
    case .celsius:
        return temperature - 273.15
    default:
        return temperature
    }
}

fileprivate func getLatitudeAndLongitude(fromCLLocation location: CLLocation) -> (latitude: Double, longitude: Double) {
    return (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
}

fileprivate func round(latitude: Double, andLongitude longitude: Double) -> (roundedLatitude: String, roundedLongitude: String) {
    let lat = String(format: "%.2f", latitude)
    let lon = String(format: "%.2f", longitude)
    return (roundedLatitude: lat, roundedLongitude: lon)
}

fileprivate func getCurrentWeatherURL(withLatitude latitude: Double, andWithLongitude longitude: Double) -> String {
    let (lat, lon) = round(latitude: latitude, andLongitude: longitude)
    return "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)"
}

fileprivate func getForecastWeatherURL(withLatitude latitude: Double, andWithLongitude longitude: Double) -> String {
    let (lat, lon) = round(latitude: latitude, andLongitude: longitude)
    return "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(lon)&cnt=10&mode=json&appid=\(API_KEY)"
}
