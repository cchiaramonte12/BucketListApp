//
//  BucketItemView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI
import MapKit

struct BucketItemView: View {
    
    @StateObject var viewModel: BucketItemViewModel
    
    @State var returnedLocation = Location(mapItem: MKMapItem())
    
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Toggle(isOn: $viewModel.item.isCompleted) {
                    Text(viewModel.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .toggleStyle(.item)
                .onChange(of: viewModel.item.isCompleted) { oldValue, newValue in
                    Task {
                        await viewModel.completeItem(value: newValue)
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: AddLocationView(viewModel: AddLocationViewModel(), returnedLocation: $returnedLocation, bucketItemViewModel: viewModel, actionAfterAddedLocation: viewModel.refresh), label: {
                    Image(systemName: "mappin.circle")
                        .foregroundColor(Color(hex: "398378"))
                })
            }
            .cornerRadius(12)
            
            if let location = viewModel.location, location.name != "Unknown Location" {
                Text("Location: \(location.name)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "398378"))
            }
        }
        .padding()
    }
}
