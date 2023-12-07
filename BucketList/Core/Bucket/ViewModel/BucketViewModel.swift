//
//  BucketViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/18/23.
//

import Foundation

class BucketViewModel: ViewModel {
    
    @Published var bucket: Bucket?
    
    let bucketId: UUID
    
    var title: String { bucket?.title ?? "" }
    
    init(id: UUID,
         bucket: Bucket?) {
        self.bucket = bucket
        self.bucketId = id
        refresh()
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
            print(error)
        }
    }
    
    func completeBucketItem(item: BucketItem, isCompleted: Bool) async {
        do {
            _ = try await FirebaseService.shared.completeBucketItem(bucketID: bucketId, itemID: item.id, isCompleted: isCompleted)
        } catch {
            print(error.localizedDescription)
        }
    }
    func addLocationToBucketItem(location: Location, bucketItemId: UUID) async {
            do {
//                _ = try await FirebaseService.shared.uploadLocation(bucketID: bucketId, itemID: bucketItemId, location: location)
                _ = try await FirebaseService.shared.uploadLocationName(bucketID: bucketId, itemID: bucketItemId, name: location.name)
                _ = try await FirebaseService.shared.uploadLocationAddress(bucketID: bucketId, itemID: bucketItemId, address: location.address)
                _ = try await FirebaseService.shared.uploadLocationLatitude(bucketID: bucketId, itemID: bucketItemId, latitude: location.latitude)
                _ = try await FirebaseService.shared.uploadLocationLongitude(bucketID: bucketId, itemID: bucketItemId, longitude: location.longitude)
            } catch {
                print(error)
            }
            
        }
    
    func deleteBucketItem(item: BucketItem) async {
        do {
            try await FirebaseService.shared.deleteBucketItem(bucketID: bucketId, itemID: item.id)
            refresh()
        } catch {
            print("failed to delete item")
            print(error.localizedDescription)
        }
    }
    
}
