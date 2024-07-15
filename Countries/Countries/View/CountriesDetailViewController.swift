//
//  CountriesDetailViewController.swift
//  Countries
//
//  Created by Avinash Thakur on 13/07/24.
//

import UIKit
import MapKit

class CountriesDetailViewController: UIViewController {

    @IBOutlet weak var flagIcon: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var continent: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var languages: UILabel!
    @IBOutlet weak var latlong: UILabel!
    
    var coordinates: CLLocation! // Coordiantes to set map region
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isZoomEnabled = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = country.name.common
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUI()
    }

    /// Function sets country details such flag icon, map with pin & other details
    func loadUI() {
        self.flagIcon.layer.cornerRadius = 8.0
        self.flagIcon.clipsToBounds = true
        self.setFlagImageFrom(imageUrl: self.country.flags.png)
        self.setMapCoordinates()
        setCountryDetails()
    }
    
    /// Function sets the flag icon for given image url
    func setFlagImageFrom(imageUrl: String) {
        if imageUrl != "" {
            NetworkManager.downloadImage(url: imageUrl) { image in
                DispatchQueue.main.async {
                    if let cachedImage = image {
                        self.flagIcon.image = cachedImage
                    } else {
                        print("Failed downloading image for url: \(imageUrl)")
                    }
                }
            }
        }
    }
    
   /// Function sets the given country's location coordinates on map with pin annotation.
    func setMapCoordinates() {
        self.coordinates = CLLocation(latitude: self.country.latlng.first ?? 0.0, longitude: self.country.latlng.last ?? 0.0)
        let regionCoordinates = CLLocationCoordinate2D(latitude: self.coordinates.coordinate.latitude, longitude: self.coordinates.coordinate.longitude)
        let region = MKCoordinateRegion(center: regionCoordinates, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
                let startPin = MKPointAnnotation()
                startPin.title = "Pin"
                startPin.coordinate = CLLocationCoordinate2D(
                    latitude: coordinates.coordinate.latitude,
                    longitude: coordinates.coordinate.longitude
                )
                mapView.addAnnotation(startPin)
    }
    
    /// function sets the country details like name,currency,language,continents, capital & lat long details.
    func setCountryDetails() {
        countryName.text = "\(CountriesConstants.name) \(self.country.name.common)"
        if let currencyStr = CountryUtility.getCurrencyString(data: self.country) {
            currency.text = "\(CountriesConstants.currency) \(currencyStr)"
        } else {
            currency.text = "\(CountriesConstants.currency) \(CountriesConstants.noCurrenciesStr)"
        }
        continent.text = "\(CountriesConstants.continent) \(CountryUtility.getContinentString(data: self.country) ?? "")"
        latlong.text = "\(CountriesConstants.latlong) \(self.country.latlng.first ?? 0.0) , \(self.country.latlng.last ?? 0.0)"
        capital.text = "\(CountriesConstants.capital) \(CountryUtility.getCommaSeparatedCapitalString(data: self.country) ?? "")"
        languages.text = "\(CountriesConstants.latlong) \(CountryUtility.getLanguagesString(data: self.country) ?? "")"
    }
    
}

extension CountriesDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }
        
        switch annotation.title {
        case "Pin":
            annotationView?.image = UIImage(named: "pin")
        default:
            break
        }
        
        return annotationView
    }
    
}
