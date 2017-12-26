//
//  MapViewController.swift
//  WorldTrotterBNR
//
//  Created by Anatoliy Chernyuk on 12/24/17.
//  Copyright © 2017 Anatoliy Chernyuk. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        mapView = MKMapView()
        mapView.showsUserLocation = false
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        let topConstrain = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let magins = view.layoutMarginsGuide
        let leadingConstrain = segmentedControl.leadingAnchor.constraint(equalTo: magins.leadingAnchor)
        let trailingConstrain = segmentedControl.trailingAnchor.constraint(equalTo: magins.trailingAnchor)
        topConstrain.isActive = true
        leadingConstrain.isActive = true
        trailingConstrain.isActive = true
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        let image = UIImage(named: "Pin.png")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        let bottomButtonConstrain = button.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -16)
        bottomButtonConstrain.isActive = true
        let trailingButtonConstrain = button.trailingAnchor.constraint(equalTo: magins.trailingAnchor)
        trailingButtonConstrain.isActive = true
    }
    
    //MARK: - CLLocationManagerDelegate
    @objc func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
        }
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            startLocationManager()
            showUserLocation()
        }
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            updatingLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    
    @objc func didTimeOut() {
        if location == nil {
            stopLocationManager()
            showLocationErrorAlert()
        }
    }
    
    func showUserLocation() {
        mapView.showsUserLocation = true
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager didFailWithError \(error)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
        showLocationErrorAlert()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        // Solution to iPod accuracy test
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude) // Assigns the MAX Double value as a distance if no previous reading was made
        if let location = location { // Calculates distance from a new reading to a previous one if there was one
            distance = newLocation.distance(from: location)
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                stopLocationManager()
            }
        } else if distance < 1 {// Using the distance and time interval to stop the locationManager
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10 {
                stopLocationManager()
            }
        }
    }
    
    func showLocationServicesDeniedAlert() {
        let alertController = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showLocationErrorAlert() {
        let alertController = UIAlertController(title: "Error Getting Location", message: "The system is not able to get current location. Please try again later", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - UISegmentedControl
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
}











































