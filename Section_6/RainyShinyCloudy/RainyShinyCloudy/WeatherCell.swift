//
//  WeatherCell.swift
//  RainyShinyCloudy
//
//  Created by Andrew Huber on 2/12/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    func updateWeatherCell(withForecastData forecast: Forecast?) {
        if let forecast = forecast {
            weatherImageView.image = UIImage(named: "\(forecast.weatherType) Mini")
            dayOfTheWeekLabel.text = forecast.date
            weatherTypeLabel.text = forecast.weatherType
            highTempLabel.text = forecast.highTemp
            lowTempLabel.text = forecast.lowTemp
        }
        else {
            weatherImageView.image = nil
            dayOfTheWeekLabel.text = NOT_SET
            weatherTypeLabel.text = NOT_SET
            highTempLabel.text = NOT_SET
            lowTempLabel.text = NOT_SET
        }
    }
}
