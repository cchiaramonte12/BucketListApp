//
//  MapViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/2/23.
//

import Foundation
import MapKit

class MapViewModel: ViewModel {
    
    
    
    var title: String { "Map" }
    
    @Published var buckets: [Bucket]?
                
    @Published var mapSelection: MKMapItem?
    
    @Published var showDetails = false
    
    @Published var getDirections = false
    
    @Published var routeDisplaying = false
    
    @Published var route: MKRoute?
    
    @Published var routeDestination: MKMapItem?
    
    init(buckets: [Bucket]? = nil, mapSelection: MKMapItem? = nil, showDetails: Bool = false, getDirections: Bool = false, routeDisplaying: Bool = false, route: MKRoute? = nil, routeDestination: MKMapItem? = nil) {
        self.buckets = buckets
        self.mapSelection = mapSelection
        self.showDetails = showDetails
        self.getDirections = getDirections
        self.routeDisplaying = routeDisplaying
        self.route = route
        self.routeDestination = routeDestination
    }
    
    func refresh() {
        Task {
            await asyncRefresh()
        }
    }
    
    var items: [BucketItem] {
        buckets?.items ?? []
    }
    
    func asyncRefresh() async {
        do {
            let buckets = try await FirebaseService.shared.getBuckets().asyncMap { try await $0.withItems() }
            
            await MainActor.run {
                self.buckets = buckets
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func fetchRoute() async {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D()))
            request.destination = mapSelection
            
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            routeDestination = mapSelection
        }
    }
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}


