//
//  MapView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/18/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var locationManager: LocationManager
        
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @StateObject var viewModel: MapViewModel
    
    var body: some View {
        Map(position: $position) {
            UserAnnotation()
            if let buckets = viewModel.buckets {
                           for bucket in buckets {
                               if let items = bucket.items {
                                   for item in items {
                                       Marker(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                                           Text(item.title)
                                       }
                                   }
                               }
                           }
                       }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}
