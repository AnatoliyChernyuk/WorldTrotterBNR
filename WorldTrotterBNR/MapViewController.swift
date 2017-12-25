//
//  MapViewController.swift
//  WorldTrotterBNR
//
//  Created by Anatoliy Chernyuk on 12/24/17.
//  Copyright © 2017 Anatoliy Chernyuk. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        mapView = MKMapView()
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
    }
    
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











































