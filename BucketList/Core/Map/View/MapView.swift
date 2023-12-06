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
                        
            ForEach(viewModel.items, id: \.self) { item in
                if let lat = item.latitude,
                   let long = item.longitude {
                    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))))
                    let placemark = mapItem.placemark
                    //                    Marker(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat),
                    //                                                              longitude: CLLocationDegrees(long))) {
                    //                        Text(item.title)
                    //                    }
                    Marker(item.title, coordinate: placemark.coordinate)
                }
            }
        }
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
