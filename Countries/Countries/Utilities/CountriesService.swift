//
//  CountriesService.swift
//  Countries
//
//  Created by Avinash Thakur on 12/07/24.
//

import Foundation

class CountriesService {
    
    /// Function fetches list for countries from server and returns completion handler with Country list and Error.
    static func getListOfCountriesFromServer(completion: @escaping ([Country], Error?) -> Void) {
        guard let serverUrl = URL(string: CountriesConstants.apiUrl) else {
            let error = NSError(domain: "Api Result Error", code: 101, userInfo: ["Desc" : "No data found"])
            completion([], error)
            return
        }
        NetworkManager.requestDataForUrl(url: serverUrl) { serverData, error in
            if let data = serverData {
                let parsedResponse = CountriesParser.parseServerResponse(serverData: data)
                if parsedResponse.1 == nil {
                    completion(parsedResponse.0, nil)
                } else {
                    completion(parsedResponse.0, parsedResponse.1)
                }
            } else {
                let error = NSError(domain: "Api Result Error", code: 101, userInfo: ["Desc" : "No data found"])
                completion([], error)
            }
        }
    }
}

class CountriesParser {
    /// Function parses the country api response.
    static func parseServerResponse(serverData: Data) -> ([Country], Error?) {
            do {
                let countryList = try JSONDecoder().decode([Country].self, from: serverData)
                print("the people list returned from server: \(countryList)")
                return (countryList, nil)
            } catch let error {
                print("error found while decoding json: \(error.localizedDescription)")
                return ([], error)
            }
    }
}
