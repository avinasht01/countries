# Countries
Project loads list of countries from server using MVVM architecture

Project displays all countries list returned from server & displays details when tapped on particular country cell.

NetworkManager - class handles url session call to server to fetch country details.

NetworkManager - Caching is enabled to cache flag icon image.

Reachability class - To check for network connection

CountriesConstants holds all constants for application

CountryUtility class has static util functions to get currency, language, etc details.

CountriesService bridges between network NetworkManager & CountriesViewModel to fetch details from server.

Used mapkit to display map on detail screen and added annotation for given latitude, longitude.
