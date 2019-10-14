//
//  AirlinesViewController.swift
//  TravelHack
//
//  Created by Nick Soong on 10/13/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import UIKit
import Foundation

struct AirlineResponse: Decodable {
  var formatted: String
}

class AirlinesViewController: UIViewController {
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var departureYearTextField: UITextField!
    @IBOutlet weak var departureMonthTextField: UITextField!
    @IBOutlet weak var departureDayTextField: UITextField!
    @IBOutlet weak var adultsTextField: UITextField!
    @IBOutlet weak var bagsTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var cabinTextField: UITextField!

      override func viewDidLoad() {
          super.viewDidLoad()

          // Do any additional setup after loading the view.
      }
    
    @IBAction func search(_ sender: UIButton) {
      
        let headers = [
          "x-rapidapi-host": "apidojo-kayak-v1.p.rapidapi.com",
          "x-rapidapi-key": "a25da40bbdmsh57e2cfbcf7b787ap1f8234jsn650295336ee0"
        ]
        
        let origin = originTextField.text!
        let destination = destinationTextField.text!
        let departure = departureYearTextField.text! + "-" + departureMonthTextField.text! + "-" + departureDayTextField.text!
        let adults = adultsTextField.text!
        let bags = bagsTextField.text!
        let currency = currencyTextField.text!
        let cabin = cabinTextField.text!
        
        let stringURL = "https://apidojo-kayak-v1.p.rapidapi.com/flights/create-session?" +
            "origin1=" + origin +
            "&destination1=" + destination +
            "&departdate1=" + departure +
            "&cabin=" + cabin +
            "&currency=" + currency +
            "&adults=" + adults +
            "&bags=" + bags
        let request = NSMutableURLRequest(url: NSURL(string: stringURL)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            if let data = data {
              print(data)
              do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
              } catch {
                print(error)
              }
            }
          }
        })

        dataTask.resume()
    }

}
