//
//  DestinationView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/13/23.
//

import SwiftUI

struct DestinationView: View {
    let destination: NavigationDestination
    var body: some View {
        switch destination {
        case .bucketView(let bucket):
                BucketView(bucket: bucket)
        case .home:
            HomeView(viewModel: .init())
        }
    }
}
