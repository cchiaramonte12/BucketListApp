//
//  AddLocationView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/10/23.
//

import SwiftUI
import MapKit

struct AddLocationView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    
    @StateObject var viewModel: AddLocationViewModel
    
    @State private var searchText = ""
    
    @Binding var returnedLocation: Location
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var bucketItemViewModel: BucketItemViewModel
    
    let actionAfterAddedLocation: () -> Void
    
    var body: some View {
        List(viewModel.locations) { location in
            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.title2)
                Text(location.address)
                    .font(.callout)
            }
            .onTapGesture {
                returnedLocation = location
                Task {
                    do {
                        await bucketItemViewModel.addLocation(name: returnedLocation.name, address: returnedLocation.address, latitude: returnedLocation.latitude, longitude: returnedLocation.longitude)
                        actionAfterAddedLocation()
                        dismiss()
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { oldValue, newValue in
            viewModel.search(text: newValue, region: locationManager.region)
        }
        .listStyle(.plain)
    }
}
