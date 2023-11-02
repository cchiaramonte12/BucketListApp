//
//  MapView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/18/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    
    @StateObject var viewModel: MapViewModel
    
//    @State private var searchText = ""
//    
//    @State private var results: [MKMapItem]
    
    var body: some View {
        Map(position: $cameraPosition, selection: $viewModel.mapSelection) {
            Annotation("", coordinate: .userLocation) {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.blue.opacity(0.25))
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.blue)
                }
            }
            ForEach(viewModel.results, id: \.self) { item in
                if viewModel.routeDisplaying {
                    if item == viewModel.routeDestination {
                        let placemark = item.placemark
                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                    }
                } else {
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                }
            }
            
            if let route = viewModel.route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
            }
        }
        .overlay(alignment: .top) {
            TextField("Search for a location...", text: $viewModel.searchText)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .padding()
                .shadow(radius: 10)
        }
        .onSubmit(of: .text) {
            Task { await viewModel.searchPlaces() }
        }
        .onChange(of: viewModel.getDirections, { oldValue, newValue in
            if newValue {
                Task {
                    await viewModel.fetchRoute()
                    withAnimation(.snappy) {
                        viewModel.routeDisplaying = true
                        viewModel.showDetails = false
                        
                        if let rect = viewModel.route?.polyline.boundingMapRect, viewModel.routeDisplaying {
                            cameraPosition = .rect(rect)
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
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 37.7749, longitude: -122.4194)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation,
                     latitudinalMeters: 10000,
                     longitudinalMeters: 10000)
    }
}
