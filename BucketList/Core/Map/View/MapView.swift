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
            
            let items: [BucketItem] = viewModel.items
            
            ForEach(items) {item in
                if let lat = item.latitude {
                    Marker(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                        Text("")
                    }
                }
                
            }
            
//            if let buckets = viewModel.buckets {
//                ForEach(buckets.items) {item in
                    
//                }
//            }
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
