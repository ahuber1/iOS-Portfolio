//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by Andrew Huber on 2/10/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//


import UIKit
import Alamofire
import CoreLocation

// Delegate: how to handle the data
// Data Source; what data to show
class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, TemperatureUnitDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tempUnitSegmentedControl: UISegmentedControl!
    
    static let NUM_FORECASTS = 7
    
    let currentWeather = CurrentWeather()
    let temperatureUnits = [TemperatureUnit.fahrenheit, TemperatureUnit.celsius, TemperatureUnit.kelvin]
    let locationManager = CLLocationManager()
    var forecasts = [Forecast?](repeating: nil, count: WeatherVC.NUM_FORECASTS)
    
    /** Makes the status bar (the topmost part of the screen displaying the time, battery status, etc.) use white text */
    override var preferredStatusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
    
    var temperatureUnitSelected: TemperatureUnit {
        return temperatureUnits[tempUnitSegmentedControl.selectedSegmentIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateLocation),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: UIApplication.shared)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.revertScreen),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: UIApplication.shared)
        
        updateLocation()
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        updateMainUI()
    }
    
    // Function 1 that should be memorized, from UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Function 2 that should be memorized, from UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    // Function 3 that should be memorized, from UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
            
        if let weatherCell = cell as? WeatherCell {
            weatherCell.updateWeatherCell(withForecastData: forecasts[indexPath.row])
        }
        
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        currentWeather.temperatureUnitDelegate = self
        currentWeather.downloadWeatherDetails(atLocation: location, {
            self.downloadForecastData(atLocation: location, completed: {
                self.updateMainUI()
            })
        })
        
        locationManager.stopUpdatingLocation()
    }
    
    func downloadForecastData(atLocation location: CLLocation, completed: @escaping DownloadComplete) {
        // Downloading forecast weather data for TableView
        let forecastURLString = getForecastWeatherURL(atLocation: location)
        let forecastURL = URL(string: forecastURLString)!
        Alamofire.request(forecastURL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for i in 0..<self.forecasts.count {
                        let obj = list[i]
                        let forecast = Forecast(weatherDict: obj)
                        forecast.temperatureUnitDelegate = self
                        self.forecasts[i] = forecast
                    }
                }
            }
            completed()
        }
    }
    
    func revertScreen() {
        dateLabel.text = NOT_SET
        currentTempLabel.text = NOT_SET
        locationLabel.text = NOT_SET
        currentWeatherTypeLabel.text = NOT_SET
        
        for i in 0..<forecasts.count {
            forecasts[i] = nil
        }
        
        tableView.reloadData()
    }
    
    func updateLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            requestUserAgainForAccessToCurrentLocation()
        }
        
        self.locationManager.startUpdatingLocation()
    }
    
    func requestUserAgainForAccessToCurrentLocation() {
        print("No access to GPS")
        
        let alert = UIAlertController(title: "Location cannot be found", message: "This app needs to have access to your location in order to display the weather at your current location. Would you like to change your settings?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [String:Any](), completionHandler: nil)
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: { action in
            let alert2 = UIAlertController(title: "Access was Not Granted", message: "Access was not granted. Unable to determine your current location.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert2.addAction(okAction)
            self.present(alert2, animated: true, completion: nil)
        })
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = currentWeather.currentTemp
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
        tableView.reloadData()
    }
}
