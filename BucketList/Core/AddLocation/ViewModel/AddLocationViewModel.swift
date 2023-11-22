//
//  AddLocationViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/10/23.
//

import Foundation
import MapKit

@MainActor
class AddLocationViewModel: ObservableObject {
    init(onTapAction: @escaping (Location) async -> Void, locations: [Location] = []) {
        self.onTapAction = onTapAction
        self.locations = locations
    }
    
    
    var onTapAction: (Location) async -> Void
    @Published var locations: [Location] = []

    func search(text: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)

        search.start { response, error in
            guard let response = response else {
                print("ERROR: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }

            self.locations = response.mapItems.map(Location.init)
        }
    }

}
