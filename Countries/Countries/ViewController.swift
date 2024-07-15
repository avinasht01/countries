//
//  ViewController.swift
//  Countries
//
//  Created by Avinash Thakur on 12/07/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var countriesTableView: UITableView!
    
    var countriesViewModel: CountriesViewModel!
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseViewModel()
        registerTableView()
        displayAllListOfCountries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = CountriesConstants.titleStr
    }
    
    /// Function initialises the view model for data interction between server and view controller.
    func initialiseViewModel() {
        countriesViewModel = CountriesViewModel()
        countriesViewModel.delegate = self
    }
    
    /// Function registers table view cells.
    func registerTableView() {
        countriesTableView.register(UINib(nibName:
                                            CountriesConstants.countriesCellIdentifier, bundle: nil), forCellReuseIdentifier: CountriesConstants.countriesCellIdentifier)
        countriesTableView.register(UINib(nibName:
                                            CountriesConstants.countriesLoadingCellIdentifier, bundle: nil), forCellReuseIdentifier: CountriesConstants.countriesLoadingCellIdentifier)
        countriesTableView.estimatedRowHeight = 150.0
        addPullToRefreshControl()
    }
    
    /// Function adds pull refresh mechanism to countries list
    func addPullToRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        countriesTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        displayAllListOfCountries()
    }
    
    /// Function fetches and displays list of all countries.
    func displayAllListOfCountries() {
        refreshControl.beginRefreshing()
        countriesViewModel.getAllListOfCountries()
    }
    
    /// Function displays alert for given errorMessage
    func displayErrorAlert(errorMessage: String? = nil) {
        let alert = UIAlertController(title: CountriesConstants.errorStr, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: CountriesConstants.okayStr, style: .default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    /// Function sets country details and loads detail view controller.
    func showDetailController(countryData: Country) {
        guard let controller = UIStoryboard.init(name: CountriesConstants.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: CountriesConstants.countriesDetailIdentifier) as? CountriesDetailViewController else {
            return
        }
        controller.country = countryData
        self.navigationItem.title = countryData.name.common
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesViewModel.getItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if countriesViewModel.dataFetchingState == .fetching {
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: CountriesConstants.countriesLoadingCellIdentifier, for: indexPath) as? LoadingTableViewCell else {
                return UITableViewCell()
            }
            return loadingCell
        }
        guard let countriesCell = tableView.dequeueReusableCell(withIdentifier: CountriesConstants.countriesCellIdentifier, for: indexPath) as? CountriesTableViewCell else {
            return UITableViewCell()
        }
        countriesCell.updateContriesCellContentUI(data: countriesViewModel.countriesList[indexPath.row])
        return countriesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if countriesViewModel.dataFetchingState == .complete {
            self.showDetailController(countryData: self.countriesViewModel.countriesList[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ViewController: CountriesViewModelDelegate {
    
    /// Function on recieving list of countries reloads countries list.
    func didReceiveListOfCountries() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.countriesTableView.reloadData()
        }
    }
    
    /// Function displays alert of network & api failure
    func failedWithError(message: String) {
        DispatchQueue.main.async {
            self.displayErrorAlert(errorMessage: message)
        }
    }
    
    /// Function reloads countries list to show loading state.
    func showLoadingState() {
        DispatchQueue.main.async {
            self.countriesTableView.reloadData()
        }
    }
    
}
