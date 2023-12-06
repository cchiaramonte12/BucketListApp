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
    
    var mapItems: [MKMapItem] {
        buckets?.items.compactMap{item -> MKMapItem? in
            guard let lat = item.latitude,
               let long = item.longitude else {
                return nil
            }
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))))
            mapItem.name = item.title
            return mapItem
        } ?? []
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
