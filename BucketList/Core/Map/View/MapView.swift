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
                Marker(item.name ?? "", coordinate: item.placemark.coordinate)
                
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
