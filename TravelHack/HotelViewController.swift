//
//  HotelViewController.swift
//  TravelHack
//
//  Created by Nick Soong on 10/14/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import UIKit
import Foundation

struct HotelResponse: Decodable {
    var hotelset: [HotelDetail]
}

struct HotelDetail: Decodable {
    var baseprice: String
    var name: String
}

class HotelViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roomTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var checkInYearTextField: UITextField!
    @IBOutlet weak var checkInMonthTextField: UITextField!
    @IBOutlet weak var checkInDayTextField: UITextField!
    @IBOutlet weak var checkOutYearTextField: UITextField!
    @IBOutlet weak var checkOutMonthTextField: UITextField!
    @IBOutlet weak var checkOutDayTextField: UITextField!
    @IBOutlet weak var adultTextField: UITextField!
    
    var setOfHotels = [HotelDetail]() {
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
        
        let rooms = roomTextField.text!
        let location = locationTextField.text!
        let checkIn = checkInYearTextField.text! + "-" + checkInMonthTextField.text! + "-" + checkInDayTextField.text!
        let checkOut = checkOutYearTextField.text! + "-" + checkOutMonthTextField.text! + "-" + checkOutDayTextField.text!
        let adults = adultTextField.text!

        let stringURL = "https://apidojo-kayak-v1.p.rapidapi.com/hotels/create-session?" +
            "rooms=" + rooms +
            "&citycode=" + location +
            "&checkin=" + checkIn +
            "&checkout=" + checkOut +
            "&adults=" + adults
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
                        let hotelResponse = try decoder.decode(HotelResponse.self, from: data)
                        let hotelDetails = hotelResponse.hotelset
                        self.setOfHotels = hotelDetails
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

extension HotelViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
//        print(#function)
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(#function)

        // #warning Incomplete implementation, return the number of rows
        return setOfHotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(#function)

        // #warning Incomplete implementation, return the number of rows
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let trip = setOfHotels[indexPath.row]
        cell.textLabel?.text = trip.name
        cell.detailTextLabel?.text = trip.baseprice
        
        return cell
    }
}
