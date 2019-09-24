//
//  ExchangeViewController.swift
//  TravelHack
//
//  Created by Nick Soong on 8/1/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import UIKit

//struct ExchangeRates {
//  let rates: [String: Double]
//  
//  init(json: [String: Any]) {
//    rates = json["rates"] as? [String: Double] ?? ["": 0.0]
//  }
//}

class ExchangeViewController: UIViewController {
  @IBOutlet var amountTextField: UITextField!
  @IBOutlet var baseTextField: UITextField!
  @IBOutlet var convertTextField: UITextField!
  @IBOutlet var convertResult: UILabel!
  
  @IBAction func convertingCurrency() {
    let baseCountry = self.baseTextField.text!.uppercased()
    let exchangeRequest = CurrencyRequest(countryCode: baseCountry)
    exchangeRequest.getExchangeRate { [weak self] result in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let exchange):
        let exchangeRates = exchange.rates
        DispatchQueue.main.async {
          let countryToSearchFor = self!.convertTextField.text!.uppercased()
          var conversionRate = 0.0
          
          //Handles the bug where user sets base current to EUR and convert currency to EUR because of JSON parsing.
          if countryToSearchFor == "EUR" && baseCountry == "EUR" {
//          if let a = exchangeRates[countryToSearchFor] {
            conversionRate = 1.0
          } else {
            if let a = exchangeRates[countryToSearchFor] {
              conversionRate = a
            } else {
              self!.showInvalidCountryCodeAlert()
              return
            }
          }
          
          if let number = self!.amountTextField.text {
            if let amountToConvert = Double(number) {
              let result = amountToConvert * conversionRate
              let format = NumberFormatter()
              format.maximumSignificantDigits = 6
              let resultFormatted = format.string(for: result)
              let baseAmountFormatted = format.string(for: amountToConvert)
              self!.convertResult.text = "\(baseAmountFormatted!) \(baseCountry) equals \(resultFormatted!) \(countryToSearchFor)"
            } else {
              self!.showNotANumberAlert()
              return
            }
          }
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  func showNotANumberAlert() {
    let alert = UIAlertController(title: "Invalid input", message: "Please input a valid number for amount of currency to convert.", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
  
  func showInvalidCountryCodeAlert() {
    let alert = UIAlertController(title: "Invalid country code", message: "Please input a valid country code for the amount in base to convert to.", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
}

