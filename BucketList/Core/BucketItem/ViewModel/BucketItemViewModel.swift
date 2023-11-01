//
//  BucketItemViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/28/23.
//

import Foundation

class BucketItemViewModel: ViewModel {
    
    
    @Published var bucket: Bucket?
    @Published var item: BucketItem
    
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
            let result = try await FirebaseService.shared.completeBucketItem(bucketID: bucketId, itemID: bucketItemId, isCompleted: value)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
