//
//  CountriesTableViewCell.swift
//  Countries
//
//  Created by Avinash Thakur on 12/07/24.
//

import UIKit

class CountriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryFlagIcon: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryContinentLabel: UILabel!
    @IBOutlet weak var countryCurrencyLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var countryData: Country!

    override func awakeFromNib() {
        super.awakeFromNib()
        setCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellUI() {
        self.selectionStyle = .none
        self.countryFlagIcon.layer.cornerRadius = 8.0
        self.countryFlagIcon.clipsToBounds = true
    }
    
    /// Function sets cell details for countries list
    func updateContriesCellContentUI(data: Country) {
        self.countryData = data
        countryNameLabel.text = self.countryData.name.common
        if let currencyStr = CountryUtility.getCurrencyString(data: self.countryData) {
            countryCurrencyLabel.text = currencyStr
        } else {
            countryCurrencyLabel.text = CountriesConstants.noCurrenciesStr
        }
        countryContinentLabel.text = CountryUtility.getContinentString(data: self.countryData)
        self.setFlagImageFrom(imageUrl: self.countryData.flags.png)
    }
    
    
    /// Function loads flag icon from cache or server and displays it on the cell
    public func setFlagImageFrom(imageUrl: String) {
        self.activityIndicator.startAnimating()
        if imageUrl != "" {
            NetworkManager.downloadImage(url: imageUrl) { image in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if let cachedImage = image {
                        self.countryFlagIcon.image = cachedImage
                    } else {
                        print("Failed downloading image for url: \(imageUrl)")
                    }
                }
            }
        }
    }
    
}
