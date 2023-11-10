//
//  Locationmanager.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/10/23.
//

import Foundation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject {

    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()

    private let locationManager = CLLocationManager()

    // need to override because of NSObject
    override init() {
        // call Apple's initializer first so we get all their stuff
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // use best accuracy when getting location
        locationManager.distanceFilter = kCLDistanceFilterNone // report all movement on device
        // request permission for location
        locationManager.requestAlwaysAuthorization()
        // start getting location
        locationManager.startUpdatingLocation() // Remember to update the Info.plist!
        locationManager.delegate = self // when iOS needs to call specific functions it expects to include, it should be here
    }

}

extension LocationManager: CLLocationManagerDelegate {
    //allowing apple's location manager to call this
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
}
