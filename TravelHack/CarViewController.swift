//
//  CarViewController.swift
//  TravelHack
//
//  Created by Nick Soong on 10/14/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import UIKit

struct CarResponse: Decodable {
    var carset: [CarDetail]
}

struct CarDetail: Decodable {
    var displayFullPrice: String
    var cheapestProviderName: String
}

class CarViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var originCityCodeTextField: UITextField!
    @IBOutlet weak var originAirportCodeTextField: UITextField!
    @IBOutlet weak var pickUpYearTextField: UITextField!
    @IBOutlet weak var pickUpMonthTextField: UITextField!
    @IBOutlet weak var pickUpDayTextField: UITextField!
    @IBOutlet weak var pickUpHourTextField: UITextField!
    @IBOutlet weak var dropOffYearTextField: UITextField!
    @IBOutlet weak var dropOffMonthTextField: UITextField!
    @IBOutlet weak var dropOffDayTextField: UITextField!
    @IBOutlet weak var dropOffHourTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    
    var setOfCars = [CarDetail]() {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func search(_ sender: UIButton) {
        let headers = [
                  "x-rapidapi-host": "apidojo-kayak-v1.p.rapidapi.com",
                  "x-rapidapi-key": "a25da40bbdmsh57e2cfbcf7b787ap1f8234jsn650295336ee0"
                ]
                
        let originCityCode = originCityCodeTextField.text!
        let originAirportCode = originAirportCodeTextField.text!
        let pickUpDate = pickUpYearTextField.text! + "-" + pickUpMonthTextField.text! + "-" + pickUpDayTextField.text!
        let pickUpHour = pickUpHourTextField.text!
        let dropOffDate = dropOffYearTextField.text! + "-" + dropOffMonthTextField.text! + "-" + dropOffDayTextField.text!
        let dropOffHour = dropOffHourTextField.text!
        let currency = currencyTextField.text!

        //https://apidojo-kayak-v1.p.rapidapi.com/cars/create-session?origincitycode=11123&originairportcode=ATL&pickupdate=2019-12-20&pickuphour=10&dropoffdate=2019-12-21&dropoffhour=16&currency=USD
        let stringURL = "https://apidojo-kayak-v1.p.rapidapi.com/cars/create-session?" +
            "origincitycode=" + originCityCode +
            "&originairportcode=" + originAirportCode +
            "&pickupdate=" + pickUpDate +
            "&pickuphour=" + pickUpHour +
            "&dropoffdate=" + dropOffDate +
            "&dropoffhour=" + dropOffHour +
            "&currency=" + currency
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
                        let carResponse = try decoder.decode(CarResponse.self, from: data)
                        let carDetails = carResponse.carset
                        self.setOfCars = carDetails
//                        print(self.setOfHotels[0].basePrice)
//                        print(self.setOfHotels[0].name)
        
                    } catch {
                        print(error)
                    }
                }
            }
        })

        dataTask.resume()
    }

}


extension CarViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
//        print(#function)
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(#function)

        // #warning Incomplete implementation, return the number of rows
        return setOfCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(#function)

        // #warning Incomplete implementation, return the number of rows
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let trip = setOfCars[indexPath.row]
        cell.textLabel?.text = trip.cheapestProviderName
        cell.detailTextLabel?.text = trip.displayFullPrice
        
        return cell
    }
}
