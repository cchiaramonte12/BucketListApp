//
//  BucketItemViewModel.swift
//  BucketList
//
//  Created by Cameron Chiaramonte on 10/28/23.
//

import Foundation
import MapKit

class BucketItemViewModel: ViewModel {
    
    var title: String { item.title }
    
    internal init(item: BucketItem,
                  bucketId: UUID,
                  onTap: @escaping (BucketItem) -> Void,
                  bucketItemCompletionMethod: @escaping (BucketItem, Bool) async -> Void,
                  bucketItemAddLocationMethod: @escaping (Location, UUID) async -> Void,
                  returnedLocation: Location = Location(mapItem: MKMapItem())) {
        self.item = item
        self.bucketId = bucketId
        self.onTap = onTap
        self.bucketItemCompletionMethod = bucketItemCompletionMethod
        self.bucketItemAddLocationMethod = bucketItemAddLocationMethod
        self.returnedLocation = returnedLocation
    }
    
    
    @Published var item: BucketItem
    let bucketId: UUID
    let onTap: (BucketItem) -> Void
    private let bucketItemCompletionMethod: (BucketItem, Bool) async -> Void
    private let bucketItemAddLocationMethod: (Location, UUID) async -> Void
    
    func completeBucketItem(bucketItem: BucketItem, isComplete: Bool) async {
        await bucketItemCompletionMethod(bucketItem, isComplete)
        await asyncRefresh()
    }
    
    func addLocationToBucketItem(location: Location) async {
        await bucketItemAddLocationMethod(location, item.id)
        await asyncRefresh()
    }
    
    @Published var returnedLocation = Location(mapItem: MKMapItem())
    
    
    func refresh() {
        Task {
            await asyncRefresh()
        }
    }
    
    func asyncRefresh() async {
        do {
            let bucketItem = try await FirebaseService.shared.getBucketItem(bucketId: bucketId, bucketItemId: item.id)
            await MainActor.run {
                self.item = bucketItem
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}


