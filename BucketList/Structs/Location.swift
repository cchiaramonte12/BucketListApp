//
//  Location.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/6/23.
//

import Foundation
import MapKit

struct Location: Identifiable {
    
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var address: String {
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        var address = ""
        
        cityAndState = placemark.locality ?? ""
        if let state = placemark.administrativeArea {
            // Show either state or city, state
            cityAndState = cityAndState.isEmpty ? state : "\(cityAndState), \(state)"
        }
        
        address = placemark.subThoroughfare ?? "" // address number
        // street name
        if let street = placemark.thoroughfare {
            // Just show street or street and #
            address = address.isEmpty ? street: "\(address) \(street)"
        }
        
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            // No address but have a city and state
            address = cityAndState
        } else {
            // No city and state, then just address, otherwise, address, city and state
            address = cityAndState.isEmpty ? address: "\(address), \(cityAndState)"
        }
        
        return address
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }
    
}
