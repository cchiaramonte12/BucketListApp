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
        Map(position: $position, selection: $viewModel.mapSelection) {
            
            UserAnnotation()
            
            ForEach(viewModel.mapItems, id: \.self) { item in
                let placemark = item.mapItem.placemark
                if viewModel.routeDisplaying {
                    if item == viewModel.routeDestination {
                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                            .tint(Color(hex: item.bucket?.color ?? "FF0000"))
                    }
                } else {
                    
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                        .tint(Color(hex: item.bucket?.color ?? "FF0000"))
                }
            }
            if let route = viewModel.route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
            }
        }
        .sheet(item: $viewModel.mapSelection) {selection in
            MapItemDetailsView(mapSelection: selection) {
                Task {
                    await MainActor.run {
                        viewModel.mapSelection = nil
                    }
                    await viewModel.fetchRoute(selectedItem: selection)
                    withAnimation(.snappy) {
                        viewModel.routeDisplaying = true
                        if let rect = viewModel.route?.polyline.boundingMapRect,
                           viewModel.routeDisplaying {
                            position = .rect(rect)
                        }
                    }
                }
            }
            
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
            viewModel.refresh()
        }
    }
}

extension MKMapItem: Identifiable {
    
}
