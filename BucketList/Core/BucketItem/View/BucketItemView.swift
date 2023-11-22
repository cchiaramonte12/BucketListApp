//
//  BucketItemView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/11/23.
//

import SwiftUI
import MapKit

struct BucketItemCardView: View {
    @StateObject var viewModel: BucketItemViewModel
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var navigationPathContainer: NavigationPathContainer
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Toggle(isOn: $viewModel.item.isCompleted) {
                    Text(viewModel.item.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .toggleStyle(.item)
                .onChange(of: viewModel.item.isCompleted) { oldValue, newValue in
                    Task {
                        await viewModel.completeBucketItem(bucketItem: viewModel.item, isComplete: newValue)
                    }
                }
                
                Spacer()
                
                TapButton {
                    navigationPathContainer.path.append(NavigationDestination.addLocation(onTapAction: viewModel.addLocationToBucketItem,
                                                                     returnedLocation: $viewModel.returnedLocation))
                } content: {
                    Image(systemName: "mappin.circle")
                        .foregroundColor(Color(hex: "398378"))
                }

            }
            .cornerRadius(12)
            
            if let name = viewModel.item.locationName {
                Text("Location: \(name)")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "398378"))
            } else {
                Text("Add a location")
                    .font(.footnote)
            }
        }
        .padding()
    }
}
