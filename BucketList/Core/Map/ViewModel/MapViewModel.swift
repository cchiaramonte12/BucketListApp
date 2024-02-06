//
//  MapViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 11/2/23.
//

import Foundation
import MapKit
import Combine

class MapViewModel: ViewModel {
    
    var title: String { "Map" }
    
    @Published var buckets: [Bucket]?
    
    @Published var mapSelection: BucketMapItem?
    
    @Published var getDirections = false
    
    @Published var routeDisplaying = false
    
    @Published var route: MKRoute?
    
    @Published var routeDestination: BucketMapItem?
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentUser: User?
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
    
    init() {
        refresh()
        setupSubscribers()
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
            guard let userId = currentUser?.id else {
                throw BucketListErrors.currentUserIdNil
            }
            let buckets = try await FirebaseService
                .shared
                .getBuckets(for: userId)
                .asyncMap { try await $0.withItems() }
            
            
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
