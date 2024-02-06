//
//  DestinationView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import MapKit
import SwiftUI

struct DestinationView: View {
    let destination: NavigationDestination
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
        case .map(let _):
            MapView(viewModel: MapViewModel())
        case .addLocation(let onTapAction, let returnedLocation):
            AddLocationView(viewModel: .init(onTapAction: onTapAction), returnedLocation: returnedLocation)
        }
    }
}
