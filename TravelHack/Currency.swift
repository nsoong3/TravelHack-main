//
//  Currency.swift
//  TravelHack
//
//  Created by Nick Soong on 8/1/19.
//  Copyright © 2019 NickSoong. All rights reserved.
//

import Foundation

struct Currency: Decodable {
  var rates: [String: Double]
}
