//
//  TimeZoneViewController.swift
//  TravelHack
//
//  Created by Nick Soong on 8/15/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import UIKit

struct TimeZoneResponse: Decodable {
  var formatted: String
}

struct TimeZoneRequest {
  let baseURL = "https://api.timezonedb.com/v2.1/get-time-zone?key="
  let apiKey = "1FYS9RQAGBVS"
  
  let resource: URL
  
  init(city: String) {
    let resourceString = baseURL + apiKey + "&format=json&by=zone&zone=" + "\(city)"
//    print("\(resourceString)")
    guard let resourceURL = URL(string: resourceString) else {
      fatalError()
    }
    self.resource = resourceURL
  }
  
  func getTimeZone (completion: @escaping(Result<String, APIError>) -> Void) {
    //    print(#function)
    
    let dataTask = URLSession.shared.dataTask(with: resource) { data,_,_  in
      guard let jsonData = data else {
        completion(.failure(.noDataAvailable))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(TimeZoneResponse.self, from: jsonData)
        let details = response.formatted
//        print("\(details)")
        completion(.success(details))
      } catch {
        completion(.failure(.cannotProcessData))
      }
    }
    dataTask.resume()
  }
}

class TimeZoneViewController: UIViewController {
  @IBOutlet weak var fromTextField: UITextField!
  @IBOutlet weak var toTextField: UITextField!
  @IBOutlet var infoLabel: UILabel!
  
  @IBAction func lookUpTimeZone(_ sender: UIButton) {
    let request = TimeZoneRequest(city: toTextField.text!)
    request.getTimeZone { result in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let timeZone):
//        print("Current time: \(timeZone)")
        DispatchQueue.main.async {
          self.infoLabel.text = self.toTextField.text! + " " + timeZone
        }
      }
    }
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
