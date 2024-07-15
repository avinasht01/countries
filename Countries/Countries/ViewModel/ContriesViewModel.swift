//
//  ContriesViewModel.swift
//  Countries
//
//  Created by Avinash Thakur on 12/07/24.
//

import Foundation

/// Enum to maintain data states while fetching list of countries from server
enum DataFetchingState {
    case idle
    case fetching
    case complete
}

/// CountriesViewModelDelegate to notify view controller with server calls success & failures.
protocol CountriesViewModelDelegate: NSObjectProtocol {
    func didReceiveListOfCountries()
    func failedWithError(message: String)
    func showLoadingState()
}

class CountriesViewModel: NSObject {
    
    var countriesList = [Country]()
    var loadingCellCount = 10 // Loading state cell count
    
    /// Data fetching state to notify view controller and update ui for data fetching & data fetching complete state.
    var dataFetchingState: DataFetchingState = .idle {
        didSet {
            switch dataFetchingState {
            case .idle: break
            case .fetching:
                self.delegate?.showLoadingState()
            case .complete:
                self.delegate?.didReceiveListOfCountries()
            }
        }
    }
    
    weak var delegate: CountriesViewModelDelegate?
    
    /// Function fetches all list for countries from server and notifies view controller thorugh data fetching state.
    func getAllListOfCountries() {
        if Reachability.isConnectedToNetwork(){
            self.dataFetchingState = .fetching
            CountriesService.getListOfCountriesFromServer { countryList, error in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    self.dataFetchingState = .complete
                    if error == nil {
                        self.countriesList = countryList
                    } else {
                        self.delegate?.failedWithError(message: error?.localizedDescription ?? "")
                    }
                })
            }
        }else{
            self.delegate?.failedWithError(message: CountriesConstants.noInternetMessage)
        }
        
    }
    
    /// function returns the item count / row count as per data fetching state. For fetching state contant 10 is returned to display only 10 cells else respective countriesList is returned.
    func getItemsCount() -> Int {
        return dataFetchingState == .fetching ? 10 : countriesList.count
    }
    
}


