//
//  Weather.swift
//  TravelHack
//
//  Created by Nick Soong on 8/13/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
  var currently: WeatherDetail
}

struct WeatherDetail: Decodable {
  var summary: String
  var icon: String
  var temperature: Double
}
