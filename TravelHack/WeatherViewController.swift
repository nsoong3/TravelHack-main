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
  @IBOutlet weak var cityNameTextField: UITextField!
  @IBOutlet weak var countryCodeTextField: UITextField!
  
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
    let weatherRequest = WeatherRequest(cityName: cityNameTextField.text!, countryCode: countryCodeTextField.text!)
    weatherRequest.getWeather { result in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let weather):
        print("Main: \(weather.weather[0].main)")
        print("Description: \(weather.weather[0].description)")
        print("Temperature: \(weather.main.temp)")
        DispatchQueue.main.async {
            self.weatherDescription.text = self.emojiIcons[weather.weather[0].main.lowercased()] ?? weather.weather[0].main
          self.weatherIcon.text = self.emojiIcons[weather.weather[0].description] ?? "\(weather.weather[0].description)"
            let localTemp = weather.main.temp
            print(self.convertToF(temp: localTemp))
            self.temperature.text = "\(self.convertToF(temp: localTemp)) °F"
        }
      }
    }
  }
    
    func convertToF(temp: Double) -> String {
        let convertTemp = (temp - 273.15) * 9.0 / 5 + 32
        let format = NumberFormatter()
        format.maximumSignificantDigits = 4
        let tempFormatted = format.string(for: convertTemp)
        return tempFormatted!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  @IBAction func dismissKeyboard() {
    cityNameTextField.resignFirstResponder()
    countryCodeTextField.resignFirstResponder()
  }

}
