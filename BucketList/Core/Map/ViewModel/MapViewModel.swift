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
    
    @Published var mapSelection: BucketMapItem?
    
    @Published var getDirections = false
    
    @Published var routeDisplaying = false
    
    @Published var route: MKRoute?
    
    @Published var routeDestination: BucketMapItem?
    
    init() {
        refresh()
    }
    
    func refresh() {
        Task {
            await asyncRefresh()
        }
    }
    
    var mapItems: [BucketMapItem] {
        buckets?.items.compactMap { itemCombo -> BucketMapItem? in
            let item = itemCombo.1
            let bucket = itemCombo.0
            guard let lat = item.latitude,
                  let long = item.longitude else {
                return nil
            }
            let mapItem = BucketMapItem(bucketItem: item, bucket: bucket,  placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))))
            mapItem.mapItem.name = item.title
            
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
    
    @MainActor
    func fetchRoute(selectedItem: BucketMapItem) async {
        
            let request = MKDirections.Request()
            request.source = .forCurrentLocation()
        request.destination = selectedItem.mapItem
            
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            routeDestination = selectedItem
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

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
    
}

class BucketMapItem: Hashable, Equatable, Identifiable {
    static func == (lhs: BucketMapItem, rhs: BucketMapItem) -> Bool {
        lhs.bucketItem == rhs.bucketItem &&
        lhs.bucket == rhs.bucket &&
        lhs.mapItem == rhs.mapItem
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(bucketItem)
        hasher.combine(bucket)
        hasher.combine(mapItem)
    }
    
    var id: ObjectIdentifier {
        mapItem.id
    }
    
    init(bucketItem: BucketItem,
         bucket: Bucket? = nil,
         placemark: MKPlacemark) {
        self.bucketItem = bucketItem
        self.bucket = bucket
        self.mapItem = .init(placemark: placemark)
    }
    
    var bucketItem: BucketItem
    var bucket: Bucket?
    var mapItem: MKMapItem
}

