//
//  DestinationView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import SwiftUI
import MapKit

struct DestinationView: View {
    let destination: NavigationDestination
    @State private var returnedLocation = Location(mapItem: MKMapItem()) // Add a state property for the returned location

    var body: some View {
        switch destination {
        case .bucketView(let id, let bucket):
            BucketView(viewModel: .init(id: id, bucket: bucket))
        case .home:
            HomeView(viewModel: .init())
        case .profile:
            ProfileView()
        case .addItem(let bucketId, let actionAfterAddedItem):
            AddItemView(bucketId: bucketId, actionAfterAddedItem: actionAfterAddedItem)
        case .createBucket:
            CreateBucketView(viewModel: CreateBucketViewModel())
        case .map(let searchText, let results, let title):
            MapView(viewModel: .init(searchText: searchText, results: results, title: title))
        case .addLocation:
            AddLocationView(viewModel: AddLocationViewModel(), returnedLocation: $returnedLocation)
        }
    }
}
