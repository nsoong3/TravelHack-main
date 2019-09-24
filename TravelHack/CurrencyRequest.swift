//
//  CurrencyRequest.swift
//  TravelHack
//
//  Created by Nick Soong on 8/1/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import Foundation

enum CurrencyError: Error {
  case noDataAvailable
  case cannotProcessData
}

struct CurrencyRequest {
  let resource: URL
  
  init(countryCode: String) {
    let resourceString = "https://api.exchangeratesapi.io/latest?base=\(countryCode)"
    
    guard let resourceURL = URL(string: resourceString) else {
      fatalError()
    }
    self.resource = resourceURL
  }
  
  func getExchangeRate (completion: @escaping(Result<Currency, CurrencyError>) -> Void) {
//    print(#function)

    let dataTask = URLSession.shared.dataTask(with: resource) { data,_,_  in
      guard let jsonData = data else {
        completion(.failure(.noDataAvailable))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let exchangeResponse = try decoder.decode(Currency.self, from: jsonData)
        let exchangeRate = exchangeResponse
//        print(exchangeRate)
        completion(.success(exchangeRate))
      } catch {
        completion(.failure(.cannotProcessData))
      }
    }
    dataTask.resume()
  }
}
