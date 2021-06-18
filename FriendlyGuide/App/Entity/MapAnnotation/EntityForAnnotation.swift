//
//  EntityForAnnotation.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 19.06.2021.
//

import Foundation
import MapKit

class EntityForAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var color: UIColor
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, color: UIColor) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.color = color
    }
}
