//
//  CountriesConstants.swift
//  Countries
//
//  Created by Avinash Thakur on 12/07/24.
//

import Foundation

struct CountriesConstants {
    static let apiUrl = "https://restcountries.com/v3.1/all"
    static let countriesCellIdentifier = "CountriesTableViewCell"
    static let countriesDetailIdentifier = "CountriesDetailViewController"
    static let countriesLoadingCellIdentifier = "LoadingTableViewCell"
    static let okayStr = "Okay"
    static let errorStr = "Error"
    static let storyboardName = "Main"
    static let titleStr = "Countries"
    static let noCurrenciesStr = "No Currency details found."
    static let name = "Name:"
    static let currency = "Currency:"
    static let continent = "Continents:"
    static let language = "Langauges:"
    static let latlong = "Lat/Long:"
    static let capital = "Capital:"
    static let noInternetMessage = "Please check your internet connection."
}

enum HTTPMethod: String {
    case post = "post"
    case get = "get"
}
