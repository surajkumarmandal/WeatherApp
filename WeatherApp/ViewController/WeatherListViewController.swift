//
//  WeatherListViewController.swift
//  WeatherApp
//
//  Created by Suraj Kumar Mandal on 15/06/22.
//

import UIKit
import GooglePlaces

class WeatherListViewController: UIViewController {
    
    @IBOutlet weak var weatherListTableView: UITableView!
    @IBOutlet weak var openMapButton: UIButton!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    let weatherDB = DBManager.sharedInstance.database.objects(WeatherListModel.self)
    
    var viewModel = WeatherListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        viewModel.delegate = self
        weatherListTableView.delegate = self
        weatherListTableView.dataSource = self
        
        //Design open map button
        openMapButton.layer.cornerRadius = openMapButton.layer.frame.height / 2
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func openMapAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension WeatherListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDB[0].weatherList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell", for: indexPath) as? WeatherListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.locationNameLabel.text = weatherDB[0].weatherList[indexPath.row].name
        cell.minTempLabel.text = "Min. Temp :\(String(format: "%.0f", weatherDB[0].weatherList[indexPath.row].main[0].temp_min - 273.15)) °C"
        cell.maxTempLabel.text = "Max. Temp :\(String(format: "%.0f", weatherDB[0].weatherList[indexPath.row].main[0].temp_max - 273.15)) °C"
        cell.descriptionLabel.text = "Description: \(String(describing: weatherDB[0].weatherList[indexPath.row].weather[0].weatherDescription ?? ""))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// Handle the user's selection.
extension WeatherListViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Call API for get weather with selected latitude and longitude.
        if Reachability.isConnectedToNetwork() {
            viewModel.getWeatherList(lat: place.coordinate.latitude, long: place.coordinate.longitude, count: 15)
        } else {
            Alert.showInternetFailureAlert(on: self)
        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        startLoader()
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        stopLoader()
    }
}

extension WeatherListViewController: WeatherListProtocol {
    func startLoader() {
        ActivityIndicator.start()
    }
    
    func stopLoader() {
        ActivityIndicator.stop()
    }
    
    func loadData() {
        weatherListTableView.reloadData()
    }
}

extension WeatherListViewController: PassLatLongDelegate {
    func getCoordinates(lat: Double, long: Double) {
        // Call API for get weather with selected latitude and longitude.
        if Reachability.isConnectedToNetwork() {
            viewModel.getWeatherList(lat: lat, long: long, count: 15)
        } else {
            Alert.showInternetFailureAlert(on: self)
        }
    }
}
