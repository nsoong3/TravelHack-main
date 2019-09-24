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

//new apiKey = pb1olU1T62KpD0vwkhIaD0dCOTPLdDfeHf8ZJ5LWSxY


struct WeatherRequest {
  let baseURL = "https://api.darksky.net/forecast/"
  let apiKey = "baf044b60e49cd7c0fc769942aa21afa"
  
  let resource: URL
  
  init(latitude: String, longitude: String) {
    let resourceString = baseURL + apiKey + "/\(latitude),\(longitude)"
    
    print("\(resourceString)")
    
    guard let resourceURL = URL(string: resourceString) else {
      fatalError()
    }
    self.resource = resourceURL
  }
  
  func getWeather (completion: @escaping(Result<WeatherDetail, APIError>) -> Void) {
    //    print(#function)
    
    let dataTask = URLSession.shared.dataTask(with: resource) { data,_,_  in
      guard let jsonData = data else {
        completion(.failure(.noDataAvailable))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let weatherResponse = try decoder.decode(WeatherResponse.self, from: jsonData)
        let weatherDetails = weatherResponse.currently
        completion(.success(weatherDetails))
      } catch {
        completion(.failure(.cannotProcessData))
      }
    }
    dataTask.resume()
  }
}
