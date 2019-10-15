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
  var tripset: [TripDetail]
}

struct TripDetail: Decodable {
    var cheapestProviderName: String
    var displayLowTotal: String
}

class AirlinesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var departureYearTextField: UITextField!
    @IBOutlet weak var departureMonthTextField: UITextField!
    @IBOutlet weak var departureDayTextField: UITextField!
    @IBOutlet weak var adultsTextField: UITextField!
    @IBOutlet weak var bagsTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var cabinTextField: UITextField!
    
    var setOfTrips = [TripDetail]() {
        didSet {
            DispatchQueue.main.async {
              self.tableView.reloadData()
            }
        }
    }
    

      override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
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
                        let decoder = JSONDecoder()
                        let airlineResponse = try decoder.decode(AirlineResponse.self, from: data)
                        let airlineDetails = airlineResponse.tripset
                        self.setOfTrips = airlineDetails
                        print(self.setOfTrips[0].cheapestProviderName)
                        print(self.setOfTrips[0].displayLowTotal)
        
                    } catch {
                        print(error)
                    }
                }
            }
        })

        dataTask.resume()
 
    }

}

extension AirlinesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
//        print(#function)
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(#function)

        // #warning Incomplete implementation, return the number of rows
        return setOfTrips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(#function)

        // #warning Incomplete implementation, return the number of rows
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let trip = setOfTrips[indexPath.row]
        cell.textLabel?.text = trip.cheapestProviderName
        cell.detailTextLabel?.text = trip.displayLowTotal
        
        return cell
    }
}
