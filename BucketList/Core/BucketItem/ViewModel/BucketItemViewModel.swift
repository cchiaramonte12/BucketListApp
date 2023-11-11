//
//  BucketItemViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/28/23.
//

import Foundation
import MapKit

class BucketItemViewModel: ViewModel {
    
    @Published var bucket: Bucket?
    @Published var item: BucketItem
//    @Published var locationName: String?
//    @Published var locationAddress: String?
//    @Published var latitude: String?
//    @Published var longitude: String?

    
    
    let bucketId: UUID
    let bucketItemId: UUID
    
    var title: String { item.title }
    
    init(bucket: Bucket? = nil, item: BucketItem, bucketId: UUID, bucketItemId: UUID) {
        self.bucket = bucket
        self.item = item
        self.bucketId = bucketId
        self.bucketItemId = bucketItemId
    }
    
    func refresh() {
        Task {
            await asyncRefresh()
        }
    }
    
    func asyncRefresh() async {
        do {
            var fetchedBucket = try await FirebaseService.shared.getBucket(id: bucketId)
            let bucketItems = try await FirebaseService.shared.getBucketItems(bucketId: bucketId)
            fetchedBucket.items = bucketItems
            let immutableFetchedBucket = fetchedBucket
            await MainActor.run {
                self.bucket = immutableFetchedBucket
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func completeItem(value: Bool) async {
        do {
            _ = try await FirebaseService.shared.completeBucketItem(bucketID: bucketId, itemID: bucketItemId, isCompleted: value)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addLocation(name: String, address: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        do {
            _ = try await FirebaseService.shared.uploadLocationName(bucketID: bucketId, itemID: bucketItemId, name: name)
            _ = try await FirebaseService.shared.uploadLocationAddress(bucketID: bucketId, itemID: bucketItemId, address: address)
            _ = try await FirebaseService.shared.uploadLocationLatitude(bucketID: bucketId, itemID: bucketItemId, latitude: latitude)
            _ = try await FirebaseService.shared.uploadLocationLongitude(bucketID: bucketId, itemID: bucketItemId, longitude: longitude)
        } catch {
            print(error)
        }
    }
}


