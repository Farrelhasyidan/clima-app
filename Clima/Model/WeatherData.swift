//
//  WeatherData.swift
//  Clima
//
//  Created by Farrel hasyidan on 24/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather : [Weather]
}

struct Main:Codable {
    let temp : Double
}

struct Weather: Codable {
    let id : Int
    let description : String
}


