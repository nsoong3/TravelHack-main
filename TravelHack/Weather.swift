//
//  Weather.swift
//  TravelHack
//
//  Created by Nick Soong on 8/13/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    var weather: [WeatherDetail]
    var main: MainDetail
}

struct MainDetail: Decodable {
    var temp: Double
}

struct WeatherDetail: Decodable {
    var main: String
    var description: String
}
