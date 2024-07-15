//
//  CountriesUtility.swift
//  Countries
//
//  Created by Avinash Thakur on 15/07/24.
//

import Foundation

class CountryUtility {
    
    /// Function retunrs Comma separated currency string for given country.
    static func getCurrencyString(data: Country) -> String? {
        var finalCurrencyStr = ""
        if let currencyJson = data.currencies?.dictionaryValue {
            let keyArray = Array(currencyJson.keys)
            
            for i in 0..<keyArray.count {
                let keyName = keyArray[i]
                guard let currencyDictionary = currencyJson[keyName]?.dictionaryValue else {
                    return nil
                }
                let name = currencyDictionary["name"]?.string ?? ""
                let symbol = currencyDictionary["symbol"]?.string ?? ""
                let currencyString = name + " " + symbol
                finalCurrencyStr.append("\(currencyString)")
                if i != keyArray.count - 1 {
                    finalCurrencyStr.append(", \n")
                }
            }
            return finalCurrencyStr
        }
        return nil
    }
    
    /// Function retunrs Comma separated continent string for given country.
    static func getContinentString(data: Country) -> String? {
        if data.continents.count == 1 {
            return data.continents.first
        } else {
            var continentString = ""
            for continent in data.continents {
                continentString.append(continent)
                continentString.append(",")
            }
            continentString.remove(at: continentString.index(before: continentString.endIndex))
            return continentString
        }
    }
    
    /// Function retunrs Comma separated capital string for given country.
    static func getCommaSeparatedCapitalString(data: Country) -> String? {
        guard let capital = data.capital else {
            return ""
        }
        if capital.count == 1 {
            return capital.first
        } else {
            var capitalString = ""
            for cap in capital {
                capitalString.append(cap)
                capitalString.append(",")
            }
            capitalString.remove(at: capitalString.index(before: capitalString.endIndex))
            return capitalString
        }
    }
    
    /// Function retunrs Comma separated languages string for given country.
    static func getLanguagesString(data: Country) -> String? {
        var finalLanguageStr = ""
        if let langJson = data.languages?.dictionaryValue {
            let keyArray = Array(langJson.keys)
            
            for i in 0..<keyArray.count {
                let keyName = keyArray[i]
                guard let langauge = langJson[keyName]?.string else {
                    return nil
                }
                finalLanguageStr.append(langauge)
                if i != keyArray.count - 1 {
                    finalLanguageStr.append(", ")
                }
            }
            return finalLanguageStr
        }
        return nil
    }
}
