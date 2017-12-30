//
//  MapViewController.swift
//  WorldTrotterBNR
//
//  Created by Anatoliy Chernyuk on 12/24/17.
//  Copyright © 2017 Anatoliy Chernyuk. All rights reserved.
//
//*** Silver Challenge solved - show zoomed user location on the map when button pressed

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
    var pins: [MKAnnotation]?
    var pinItem = 1
    
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
        
        let locationButton = UIButton(type: .system)
        locationButton.backgroundColor = UIColor.clear
        let image = UIImage(named: "Tag.png")
        locationButton.setImage(image, for: .normal)
        locationButton.sizeToFit()
        locationButton.addTarget(self, action: #selector(showUserLocation), for: .touchUpInside)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationButton)
        let bottomLocationButtonConstrain = locationButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -16)
        bottomLocationButtonConstrain.isActive = true
        let trailingLocationButtonConstrain = locationButton.trailingAnchor.constraint(equalTo: magins.trailingAnchor)
        trailingLocationButtonConstrain.isActive = true
        
        let pinsButton = UIButton(type: .system)
        pinsButton.backgroundColor = UIColor.clear
        let pinsImage = UIImage(named: "Pin.png")
        pinsButton.setImage(pinsImage, for: .normal)
        pinsButton.sizeToFit()
        pinsButton.addTarget(self, action: #selector(showPins), for: .touchUpInside)
        pinsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pinsButton)
        let bottomPinsButtonConstrain = pinsButton.bottomAnchor.constraint(equalTo: locationButton.topAnchor, constant: -16)
        bottomPinsButtonConstrain.isActive = true
        let trailingPinsButtonConstrain = pinsButton.trailingAnchor.constraint(equalTo: magins.trailingAnchor)
        trailingPinsButtonConstrain.isActive = true
        
        
        
        
    }
    
    //MARK: - MKMapViewDelegate
    func requestStatus() -> Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return true
        }
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return true
        }
        return false
        /*
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            startLocationManager()
            showUserLocation()
        */
    }
    
    @objc func showUserLocation() {
        //solution learned from iOS Apprentice
        //mapView.showsUserLocation = true
        //let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        //mapView.setRegion(mapView.regionThatFits(region), animated: true)
        if requestStatus() {
            return
        }
        if let pins = pins {
            mapView.removeAnnotations(pins)
        }
        mapView.userTrackingMode = .follow //The best solution! Got it from the forum
        mapView.showsUserLocation = true
    }
    
    @objc func showPins() {
        if requestStatus() {
            return
        }
        if pins == nil {
            pins = [MKAnnotation]()
            mapView.showsUserLocation = false
            pins!.append(mapView.userLocation)
            let bacotaPin = Pin(title: "Bacota Bay", coordinate: CLLocationCoordinate2D(latitude: 48.585714, longitude: 26.998488), subtitle: "Love to come here")
            pins!.append(bacotaPin)
            let maliyivtsiPin = Pin(title: "Maliyivtsi", coordinate: CLLocationCoordinate2D(latitude: 48.991991, longitude: 26.996249), subtitle: "Nice place to visit")
            pins!.append(maliyivtsiPin)
            mapView.addAnnotation(pins![0] as MKAnnotation)
            mapView.userTrackingMode = .follow
        } else {
            mapView.showsUserLocation = false
            if pinItem == 3 {
                pinItem = 0
            }
            mapView.removeAnnotations(pins!)
            mapView.addAnnotation(pins![pinItem])
            let region = MKCoordinateRegionMakeWithDistance(pins![pinItem].coordinate, 1000, 1000)
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
            pinItem += 1
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
    
    /*
    //MARK: - CLLocationManagerDelegate - not used in this example as MKMapViewDelegate API is enough
     
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("Location Manager didFailWithError \(error)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
        showLocationErrorAlert()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        //print("didUpdateLocations \(newLocation)")
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
     
    */
}











































