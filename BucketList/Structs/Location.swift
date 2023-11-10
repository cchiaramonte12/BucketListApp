//
//  Location.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/10/23.
//

import Foundation
import MapKit

struct Location: Identifiable, Codable {

    var id = UUID().uuidString
    private var mapItem: MKMapItem

    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case latitude
        case longitude
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let address = try container.decode(String.self, forKey: .address)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)

        // Create MKMapItem from decoded properties
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name

        self.mapItem = mapItem
    }

    // Custom encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }

}
