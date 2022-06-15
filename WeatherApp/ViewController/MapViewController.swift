//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Suraj Kumar Mandal on 15/06/22.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    var userLatitude = Double()
    var userLongitude = Double()
    
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: PassLatLongDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Set done button in navigation bar
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        self.navigationItem.rightBarButtonItem  = doneBarButtonItem
        // Hide back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Set title
        self.navigationItem.title = "Pick Location"
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.isMyLocationEnabled = true
        mapView.animate(toViewingAngle: 45)
        mapView.delegate = self
    }
    
    @objc func doneAction() {
        // call this method on whichever class implements our delegate protocol
        delegate?.getCoordinates(lat: self.userLatitude, long: self.userLongitude)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last // find your device location
        mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 14.0) // show your device location on map
        mapView.settings.myLocationButton = true // show current location button
        let lat = (newLocation?.coordinate.latitude)! // get current location latitude
        let long = (newLocation?.coordinate.longitude)! //get current location longitude
        // Set user latitude and longitude
        self.userLatitude = lat
        self.userLongitude = long
        
        marker.position = CLLocationCoordinate2DMake(lat,long)
        marker.map = mapView
        print("Current Lat Long - " ,self.userLatitude, self.userLongitude )
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        DispatchQueue.main.async {
            let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.marker.position = position
            self.marker.map = mapView
            self.marker.icon = UIImage(named: "location-pin")
            // Set user latitude and longitude
            self.userLatitude = coordinate.latitude
            self.userLongitude = coordinate.longitude
            print("New Marker Lat Long - ",coordinate.latitude, coordinate.longitude)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// protocol used for sending data back
protocol PassLatLongDelegate: AnyObject {
    func getCoordinates(lat: Double, long: Double)
}
