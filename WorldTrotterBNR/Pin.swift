//
//  Pin.swift
//  WorldTrotterBNR
//
//  Created by Anatoliy Chernyuk on 12/28/17.
//  Copyright © 2017 Anatoliy Chernyuk. All rights reserved.
//

import UIKit
import MapKit

class Pin: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    init(title: String?, coordinate: CLLocationCoordinate2D, subtitle: String?) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }

}
