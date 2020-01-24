//
//  DarkSkyService.swift
//  TravelHack
//
//  Created by Nick Soong on 8/13/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import Foundation

enum APIError: Error {
  case noDataAvailable
  case cannotProcessData
}

struct WeatherRequest {
//https://api.openweathermap.org/data/2.5/forecast?q=London,UK&appid=528c07412d10f3145ced88bdecfdde14
  let baseURL = "https://api.openweathermap.org/data/2.5/weather?q="
  let apiKey = "&appid=528c07412d10f3145ced88bdecfdde14" //
  
  let resource: URL
  
  init(cityName: String, countryCode: String) {
    let resourceString = baseURL + "\(cityName),\(countryCode)" + apiKey
    
    print("\(resourceString)")
    
    guard let resourceURL = URL(string: resourceString) else {
      fatalError()
    }
    self.resource = resourceURL
  }
  
  func getWeather (completion: @escaping(Result<WeatherResponse, APIError>) -> Void) {
    //    print(#function)
    
    let dataTask = URLSession.shared.dataTask(with: resource) { data,_,_  in
      guard let jsonData = data else {
        completion(.failure(.noDataAvailable))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let weatherResponse = try decoder.decode(WeatherResponse.self, from: jsonData)
        let weatherDetails = weatherResponse
        completion(.success(weatherDetails))
      } catch {
        completion(.failure(.cannotProcessData))
      }
    }
    dataTask.resume()
  }
}
