//
//  CountriesModel.swift
//  Countries
//
//  Created by Avinash Thakur on 12/07/24.
//

import Foundation
import SwiftyJSON

struct Country: Codable {
    let name: CountryName
    let currencies: JSON?
    var continents: [String]
    var flags: Flags
    var latlng: [Double]
    var capital: [String]?
    var languages: JSON?
}

struct CountryName: Codable {
    let common: String
}

struct Flags: Codable {
    var png: String
}

struct LatLong: Codable {
    var lat: UInt32
    var long: UInt32
}

