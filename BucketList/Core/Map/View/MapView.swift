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
            
            ForEach(viewModel.items) {item in
                if let lat = item.latitude,
                   let long = item.longitude {
                    Marker(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat),
                                                              longitude: CLLocationDegrees(long))) {
                        Text(item.title)
                    }
                }
            }
            if let route = viewModel.route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
            }
        }
        .onChange(of: viewModel.getDirections, { oldValue, newValue in
            if newValue {
                Task {
                    await viewModel.fetchRoute()
                    withAnimation(.snappy) {
                        viewModel.routeDisplaying = true
                        viewModel.showDetails = false
                        
                        if let rect = viewModel.route?.polyline.boundingMapRect, viewModel.routeDisplaying {
                            position = .rect(rect)
                        }
                    }
                }
            }
        })
        .onChange(of: viewModel.mapSelection, { oldValue, newValue in
            viewModel.showDetails = newValue != nil
        })
        .sheet(isPresented: $viewModel.showDetails, content: {
            MapItemDetailsView(mapSelection: $viewModel.mapSelection, show: $viewModel.showDetails, getDirections: $viewModel.getDirections)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        })
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

