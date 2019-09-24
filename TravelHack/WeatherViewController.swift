//
//  WeatherViewController.swift
//  TravelHack
//
//  Created by Nick Soong on 8/13/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
  @IBOutlet weak var weatherDescription: UILabel!
  @IBOutlet weak var temperature: UILabel!
  @IBOutlet weak var weatherIcon: UILabel!
  @IBOutlet weak var latitudeTextField: UITextField!
  @IBOutlet weak var longitudeTextField: UITextField!
  
  let emojiIcons = [
    "clear-day": "☀️",
    "clear-night": "🌙",
    "rain": "☔️",
    "snow": "❄️",
    "sleet" : "🌨",
    "wind": "🌬",
    "fog": "🌫",
    "cloudy": "☁️",
    "partly-cloudy-day": "🌤",
    "partly-cloudy-night": "🌥"
  ]
  
  @IBAction func weatherForecast() {
    let weatherRequest = WeatherRequest(latitude: latitudeTextField.text!, longitude: longitudeTextField.text!)
    weatherRequest.getWeather { result in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let weather):
        print("Summary: \(weather.summary)")
        print("Icon: \(weather.icon)")
        print("Temperature: \(weather.temperature)")
        DispatchQueue.main.async {
          self.weatherDescription.text = weather.summary
          self.weatherIcon.text = self.emojiIcons[weather.icon] ?? "❓"
          self.temperature.text = "\(weather.temperature) °F"
        }
      }
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
