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
                    
    init() {
        refresh()
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
            request.source = MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(items[0].latitude ?? 0.0), longitude: CLLocationDegrees(items[0].longitude ?? 0.0))))
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
