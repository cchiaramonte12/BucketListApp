//
//  AddLocationView.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/6/23.
//

import SwiftUI

struct AddLocationView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    
    @StateObject var viewModel: AddLocationViewModel
    
    var body: some View {
        VStack {
            
            List(viewModel.locations) { location in
                VStack(alignment: .leading) {
                    Text(location.name)
                        .font(.title2)
                    Text(location.address)
                        .font(.callout)
                }
            }
            .listStyle(.plain)
        }
    }
}
