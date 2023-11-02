//
//  MapViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/2/23.
//

import Foundation
import MapKit

class MapViewModel: ViewModel {
    
    @Published var searchText: String
    
    @Published var results: [MKMapItem]
    
    @Published var buckets: [Bucket]?
    
    @Published var mapSelection: MKMapItem?
    
    @Published var showDetails = false
    
    @Published var getDirections = false
    
    @Published var routeDisplaying = false
    
    @Published var route: MKRoute?
    
    @Published var routeDestination: MKMapItem?
    
    
    
    var title: String { "Map" }
    
    init(searchText: String, results: [MKMapItem], title: String) {
        self.searchText = searchText
        self.results = results
    }
    
    func refresh() {
        Task {
            await asyncRefresh()
        }
    }
    
    func asyncRefresh() async {
        do {
            let buckets = try await FirebaseService.shared.getBuckets()
            
            await MainActor.run {
                self.buckets = buckets
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
    
    @MainActor
    func fetchRoute() async {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            request.destination = mapSelection
            
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            routeDestination = mapSelection
        }
    }
}
