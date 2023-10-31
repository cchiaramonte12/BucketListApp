//
//  MapView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/18/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var cameraPosition =
        MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))

        var body: some View {
            Map(position: $cameraPosition)
                .edgesIgnoringSafeArea(.all)
        }
}

#Preview {
    MapView()
}
