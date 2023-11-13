//
//  ViewController.swift
//  GoogleMapIntegration
//
//  Created by Rohit Kumar on 13/11/2023.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    func checkLocationServices() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.mapView.settings.myLocationButton = true
                self.setupLocationManager()
                self.checkLocationAuthorization()
                self.startTrackingUserLocation()
            } else {
                // show Alert Letting the user know they have to turn location on.
            }
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways, .denied:
            break
        case .notDetermined , .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startTrackingUserLocation() {
        mapView.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
    }
 
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // or requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 8, bearing: 0, viewingAngle: 0)

            let marker = GMSMarker()
            marker.position = location.coordinate
            marker.title = "Hello Rohit"
            marker.snippet = "I'm here"
            marker.map = mapView
        }
    }

}
