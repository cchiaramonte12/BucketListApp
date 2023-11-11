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
