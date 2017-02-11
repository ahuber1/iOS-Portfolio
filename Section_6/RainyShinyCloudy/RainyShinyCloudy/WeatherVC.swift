//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by Andrew Huber on 2/10/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

// Delegate: how to handle the data
// Data Source; what data to show
class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let currentWeather = CurrentWeather()
        currentWeather.downloadWeatherDetails(completed: { })
    }
    
    // Function 1 that should be memorized, from UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Function 2 that should be memorized, from UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    // Function 3 that should be memorized, from UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        return cell
    }
}

